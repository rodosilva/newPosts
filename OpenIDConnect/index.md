+++
date = '2026-06-09T18:51:17-05:00'
title = 'OpenIDConnect (OIDC) Deploy Infrastructure into AWS using OIDC Auth in GitHub Actions'
+++

# QUÉ ES OIDC

`OIDC` EL propósito es delegar la autenticación de AWS hacia GitHub Actions
  
# DOCUMENTACIÓN
- [Conectar GitHub Actions con AWS usando OIDC](https://adeployguru.medium.com/conectar-github-actions-con-aws-usando-oidc-f0e504eeea48)
- [Configurar OpenID Connect en Amazon Web Services](https://docs.github.com/es/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws)
- [Securely deploy to AWS with GitHub Actions and OIDC](https://youtu.be/Io5UFJlEJKc?si=sJ8_ecE5-g9CaKMw)
- [OIDC Demo](https://github.com/manchicken/ghu23-oidc-talk/tree/main)
- [Deploy to AWS with Terraform Using GitHub Actions (Secure OIDC Setup)](https://github.com/amir-cloud-security/terraform-test-oidc)
-  [Deploy to AWS with Terraform Using GitHub Actions (Secure OIDC Setup) - VIDEO](https://youtu.be/kGJ3p1mZC3g?si=bpuni345bNX0_Ltj)
# DIAGRAMA

![](Pasted%20image%2020260609210928.png)

# PASO 1: DESDE CONSOLA AWS

## Crear Proveedor de Identidad
Como primer paso tendremos que utilizar un proveedor de identidad `IDP` para administrar las identidades de personas fuera de `AWS`.

Para ello iremos a `IAM -> identity_providers -> Add provider`
  
| Tipo de proveedor | Proveedor                                   | Público           |
| ----------------- | ------------------------------------------- | ----------------- |
| OpenID Connect    | https://token.actions.githubusercontent.com | sts.amazonaws.com |

Al configurar obtendremos el `arn`: `arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com`

## IAM Role: Relación de Confianza
Luego, debemos crear un `IAM ROLE`. En mi caso lo llamaré: `test-OIDC-role`

Y añadiremos una `Relación de Confianza`. Que finalmente son entidades que pueden asumir este rol en condiciones especificadas.

**Ejemplo de Relación de Confianza

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": [
                        "repo:<OWNER>/<REPO>:*"
                    ]
                }
            }
        }
    ]
}
```

**_NOTA:_** _Considerar que en mi caso `<OWNER>/<REPO>` sería mi repositorio GitHub: rodosilva/openIDConnect_

## IAM Role: Policy

Finalmente añadiremos los permisos/políticas. En mi caso lo llamaré: `test-OIDC-policy`

Recordemos que una política es un objeto de AWS que, cuando se asocia a una identidad o un recurso, define los permisos.

**Ejemplo de Policy**  

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowGetCallerIdentity",
            "Effect": "Allow",
            "Action": "sts:GetCallerIdentity",
            "Resource": "*"
        }
    ]
}
```

**_NOTA:_** _Naturalmente esta policy es sumamente limitada pues es solo para ejemplificar_

Con esto obtenemos el `arn`: `arn:aws:iam::<ACCOUNT_ID>:role/test-OIDC-role`

# PASO 2: DESDE EL REPOSITORIO
Ahora que tenemos la consola de `AWS` configurada, podemos avanzar en nuestro repositorio.
Naturalmente deberemos tener un repositorio creado en `GitHub`. En mi caso es [openIDConnect](https://github.com/rodosilva/openIDConnect) 
Una vez clonado, crearemos la ruta `./.github/workflows` y un archivo `yaml` que llamaré `get-caller-identity.yml`

**Ejemplo de workflow**

```yaml
on:
  workflow_dispatch:

jobs:
  get_caller_identity:
    name: Get Caller Identity
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Configure AWS credentials from Test account
        uses: aws-actions/configure-aws-credentials@v3
        with:
          role-to-assume: arn:aws:iam::710434794054:role/test-OIDC-role
          aws-region: us-east-1
      - name: Fetch the caller identity
        run: |
          aws sts get-caller-identity
```

Ya con todo esto solo queda probar.

Luego del `commit` y `push` nos vamos al `https://github.com/rodosilva/openIDConnect --> actions --> Run Job`

![](Pasted%20image%2020260609211832.png)

# CONCLUSIÓN
## Resumen
Este proyecto demuestra una implementación segura y moderna de autenticación entre **GitHub Actions** y **AWS** utilizando **OpenID Connect (OIDC)**. A través de este flujo, hemos eliminado la necesidad de gestionar credenciales de acceso estáticas (AWS Access Keys), reemplazándolas por un mecanismo de autenticación temporalizado y federado.

## Beneficios Clave
✅ **Sin Credenciales Hardcodeadas**: No es necesario almacenar claves de acceso de AWS en secretos de GitHub

✅ **Tokens Temporales**: Cada ejecución utiliza un token JWT de corta duración generado por GitHub

✅ **Auditoría Mejorada**: AWS registra exactamente qué repositorio y rama ejecutó cada acción

✅ **Control Granular**: Las políticas IAM permiten especificar qué repositorios y ramas pueden asumir roles específicos

✅ **Menor Riesgo de Seguridad**: Reducción significativa de la superficie de ataque al eliminar credenciales de largo plazo

## Flujo General
1. **GitHub Actions** genera un token JWT cuando se ejecuta un workflow
2. El token se envía a **AWS STS** (Security Token Service) para intercambiarlo por credenciales temporales
3. El proveedor OIDC de AWS valida la autenticidad del token
4. Si las condiciones de confianza se cumplen, se asume el IAM Role especificado
5. El workflow obtiene permisos limitados por la política del rol
## Casos de Uso
Este enfoque es ideal para:

- Deployments automatizados de infraestructura con `Terraform` o `CloudFormation`
- `CI/CD pipelines` seguros sin exposición de credenciales
- Integración de múltiples repositorios GitHub con una arquitectura AWS controlada
- Organizaciones que requieren compliance y auditoría estricta
## Próximos Pasos
Para ampliar este ejemplo, considera:

- Implementar diferentes roles IAM para distintos repositorios o ambientes
- Agregar políticas más granulares (por ejemplo, permisos limitados a recursos específicos)
- Automatizar el deployment de infraestructura real usando Terraform
- Configurar notificaciones y alertas para monitorear asunciones de roles

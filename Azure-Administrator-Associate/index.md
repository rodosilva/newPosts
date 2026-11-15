+++
date = '2026-09-27T10:34:07-05:00'
title = 'Azure Administrator Associate'
+++

## FUNDAMENTOS Y ARQUITECTURA DE MICROSOFT AZURE
Microsoft Azure es un proveedor de Cloud

**Casos de Uso**
- IT para empresas
- Copias de seguridad
- Alejamiento de sitios Web
- IA y Machine Learning

**Precios de Cloud**
- Computación
- Almacenamiento
- Transferencia de datos FUERA del Cloud (Transferencias hacia adentro es gratuita)

**Modelo de Responsabilidad Compartida**
- Responsabilidad del cliente
	- Información, datos
	- Dispositivos
	- Identidades
- La responsabilidad varia en función del tipo
	- Identidad e infraestructura de directorios
	- Aplicaciones
	- Controles de red
	- OS
- La responsabilidad es de Azure
	- Hosts físicos
	- Red física
	- Centro de datos físico

**Infraestructura Global de Azure**
- **Regiones: **Ubicaciones geográficas donde Azure tiene centros de datos
	- **Regiones emparejadas:** Pares de regiones para resiliencia y recuperación ante desastres
	- **Regiones soberanas:** Regiones que cumplen con regulaciones
- **Zonas de disponibilidad:** Áreas dentro de una región para alta disponibilidad
- **Centros de datos de Azure:** Instalaciones físicas
- **Puntos de presencia: PoP:** Ubicaciones globales para acceso rápido a servicios de red

## REQUISITOS PREVIOS PARA ADMINISTRADORES DE AZURE

### Azure Portal
- [Azure Portal](https://portal.azure.com/)
Se encuentra el cada centro de datos. No requiere tiempo de inactividad para las actividades de mantenimiento

### Azure CLI
Herramienta de línea de comandos basada en `BASH` para multiples OS
`az --version`

### Azure Power Shell
Herramienta de línea de comandos que te permite administrar recursos de Microsoft Azure
Se integra con la autenticación de Azure

### Azure Cloud Shell
Accede a un shell Bash o Powershell directamente desde el navegador sin necesidad de instalación.

### Visión General de Bash
**Bash** significa `Bourne Again Shell` y es el shell estándar de facto en Linux. Compatible con el shell original de Unix (sh)

### Azure Advisor
Consultor personalizado en la nube
Analiza la configuración de recursos y telemetría
Puedes:
- Obtener sugerencias
- Mejorar rendimiento
- Identifica oportunidades

## GOBERNANZA EN MICROSOFT AZURE

### Gobernanza de Azure AZ-104
Se refiere al conjunto de servicios, políticas y controles que te permiten gestionar los recursos.


| Definir Políticas Corporativas | Definir Políticas Corporativas | Definir Políticas Corporativas |
| ------------------------------ | ------------------------------ | ------------------------------ |
| Riesgo empresarial             | Política y Cumplimiento        | Procesio                       |
**Cinco disciplinas de la gobernanza en la nube**
- Gestión de costos
- Línea base de Seguridad
- Consistencia de recursos: Creación homogénea
- Línea base de identidad: Definición de roles y asignaciones
- Aceleración de despliegue: Estandarización en plantillas de despliegue

### Recursos Y Grupos de Recursos
Un elemento administrable:
- Maquinas virtuales
- Aplicaciones web
- Bases de datos
- Redes virtuales

Un **grupo de recursos** es un contenedor que almacena los recursos relacionados con una solución de `Azure`

### Suscripciones
Permiten organizar y controlar el acceso, costos y facturación
Útiles para separar diferentes unidades de trabajo, proyectos o entornos
Cada `suscripción` tiene límites en la cantidad y tipo de recursos que puedes crear

- [lïmites](https://learn.microsoft.com/es-es/azure/azure-resource-manager/management/azure-subscription-service-limits)

NOTA: Se puede tener múltiples `suscripciones` en una sola cuenta

### Grupos de Administración
Es una estructura jerárquica que permite organizar y administrar múltiples suscripciones de Azure.
![](Pasted%20image%2020260927150759.png)
- Aplica políticas e iniciativas consistentemente a todas las suscripciones y recursos de manera unificada

## Visión General de Azure Policy
Permite aplicar estándares organizaciones y evaluar cumplimiento
Evita configuraciones incorrectas
Ofrece un panel de cumplimiento con visibilidad global
![](Pasted%20image%2020260927151304.png)

**Cumplimiento de políticas con Azure Policy**
Auditar las políticas desde `Azure Policy`
![](Pasted%20image%2020260927151502.png)

**Niveles de gobernanza en Azure**
- Grupo raíz
- Grupos de administración
- Suscripciones
- Grupos de recursos
- Recursos

Políticas heredadas de arriba hacia abajo

**Políticas en Recursos**
- `Directiva -> Creación -> Definiciones`
- Asignaciones
- Exenciones

### Uso de Políticas

```json
      "policyEffect": {
        "type": "String",
        "metadata": {
          "displayName": "Efecto de la directiva",
          "description": "Efecto deseado de la directiva."
        },
        "allowedValues": [
          "audit",
          "Audit",
          "deny",
          "Deny",
          "disabled",
          "Disabled"
        ],
        "defaultValue": "Deny"
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.DocumentDB/databaseAccounts"
          },
          {
            "count": {
              "field": "Microsoft.DocumentDB/databaseAccounts/Locations[*]",
              "where": {
                "value": "[replace(toLower(first(field('Microsoft.DocumentDB/databaseAccounts/Locations[*].locationName'))), ' ', '')]",
                "in": "[parameters('listOfAllowedLocations')]"
              }
            },
            "notEquals": "[length(field('Microsoft.DocumentDB/databaseAccounts/Locations[*]'))]"
          }
        ]
      },
      "then": {
        "effect": "[parameters('policyEffect')]"
      }
    }
```

### Muestras de Políticas (Directivas)

- [Muestra](https://github.com/Azure/azure-policy)

### Azure Cost Management
- Asignar costes
- Exportar de datos
- Políticas de costos
- Integración con herramientas
- Informe de ineficiencias
- Comparativas de precios
- Vistas personalizadas

**Definición de Presupuestos**
Límites de gastos y establecer alertas.

**Facturación**
Ofrecen un desglose detallado de los gastos

**Presupuesto**
**Tags**
### Locks (Candados- Bloqueos)
Los locks protegen los recursos de Azure evitando su eliminación accidental o modificación
- **Tipos**
	- Read only: No se haga modificaciones
	- Delete: No se puede eliminar
- Asignación
- Jerarquía de aplicación

## MICROSOFT ENTRA ID (Ex ACTIVE DIRECTORY)

### General
Gestión de identidades en la nube.
No debe confundirse con el Active Directory tradicional.
- Gestión de identidades y de acceso SSO y MFA
- Integración de aplicaciones
- Desarrollo de aplicaciones
- Seguridad e inteligencia

B2B y B2C

**Inquilino Tenant**
Representa a una organización
Instancia dedicada de Microsoft Entra ID
Un inquilino es independiente de los otros.

**Arquitectura Híbrida con Entra ID**
`Cloud de Azure` ---(`Entra ID`)--> `Centro de datos Local`
![](Pasted%20image%2020261005195416.png)

- https://entra.microsoft.com

### Licencias de Microsoft Entra ID
Licencia: Permite acceder legalmente a servicios de pago
Define qué productos y servicios puede usar cada usuario
Son obligatorias para cumplir los contratos de uso y evitar sanciones

**Tipos**
Gratis, P1, P2, Gobernanza

- Microsoft Entra ID Gratis
- Microsoft Entra ID P1: Acceso híbrido
- Microsoft Entra ID P2: Añade capa de seguridad. Just in time
- Microsoft Entra ID Governance: Pago por uso. Control sobre múltiples dominios
	- Entra domain Services
	- CIAM: Administración de identidades

**Precios**
https://www.microsoft.com/es-es/security/business/microsoft-entra-pricing

**Plan P1**
- Autoservicio de grupos
- Informes y alertas avanzadas
- MFA
- Microsoft Identity Manager: Enlaza almacenes locales
- SLA del 99.9%
- Restablecimiento de contraseñas
- Cloud App Discovery
- Acceso condicional
- Entra Connect Health

**Plan P2**
- Protección de Entra ID. Supervisión de cuentas
- PIM Gestión de accesos con privilegios
- Define reglas y flujos de aprobación para elevar privilegios

**Licencias Individuales Vs en Grupo**
Microsoft Entra ahora admite licencias asignadas por grupos

### Creación Configuración Y administración de Usuarios
Al autenticarse con Entra ID
- Se crea un Token
- Tipos
	- Identidades en la nube: Existen solo en el directorio de MS Entra
	- Identidades sincronizadas por directorio: AD con Microsoft Entra Connect
	- Usuarios Invitados: Usuarios con Gmail, Xbox, etc

Se puede hacer importación de usuarios por `.csv`

**Usuarios Externos**
Otro Dominio

### Grupos
Asignar permisos a todos los miembros a la vez
No necesitas configurar usuario por usuario
Se puede usar reglas para definir la pertenencia


| Grupo           | Grupo de seguridad           | Grupos de Microsoft 365                  |
| --------------- | ---------------------------- | ---------------------------------------- |
| Administradores | Lo más común en Entra        | Usados para colaboración y productividad |
| Ventas          | Controla acceso              | Acceso a Buzón y calendario compartido   |
| Operaciones     | Según políticas de seguridad | Colaboración con usuarios externos       |

**Tipos de pertenencia en Grupos**
- **Asignado (Assigned):** Opción manual
- **Dinámico (Dynamic):** Miembros agregados automáticamente según reglas basadas en atributos (Se necesita P1 o P2). Para ambos grupos. La membresía se actualiza automáticamente cuando los atributos cambian

En cuanto a `atributos` puede ser varias cosas, por ejemplo, por país.
Si es dinámico, no puedes añadir de forma manual.

### Restablecer La Contraseña: SSPR
Auto servicio para que los usuarios cambien su contraseña

### Atributos de Seguridad Personalizados
Son pares clave-valor
Se asignan a objetos de Microsoft Entra
**Casos de Uso**
- Almacenar información
- Clasificar objetos
- Aplicar control de acceso sobre recursos de Azure

### Creación Automática de Usuarios
![](Pasted%20image%2020261005211927.png)
Usamos un protocolo llamado `SCIM` 
Estándar para aprovisionamiento automático de usuarios y grupos
- Sistema HCM
- Entra ID
- Sistema destino
- Microsoft Entra Provisioning Service: API Rest

**Por qué usar SCIM**
- Automatiza el intercambio de información de identidad entre dominios
- Empleados en HCM: Crean cuentas automáticamente en Entra ID o AD
- Sincroniza atributos y perfiles de usuarios entre sistemas
- Gestiona eliminación de usuarios al cambiar de rol o salir de la organización

### Microsoft Entra ID Vs Active Directory Domain Services (Azure AD DS)
**Azure AD DS** 
autenticación, autorización y la aplicación de políticas de seguridad
Esencial para las organizaciones que desean migrar apps al cloud sin perder las funcionalidades del AD
Unificar on-premises y nube
Soporta protocolos antiguos `NTLM` y `Kerberos`

- Azure AD DS es un servicio gestionado
- Crea un nombre de dominio/espacio de nombres único
- Sincronización unidireccional de Microsoft Entra ID a Azure AD DS
![](Pasted%20image%2020261005212958.png)

**Casos de uso Azure AD DS**
- Migración de aplicaciones
- Desarrollo y pruebas

**Comparación Entra ID vs AD DS**
![](Pasted%20image%2020261005213232.png)

## CONTROL DE ACCESO BASADO EN ROLES: RBAC
Que acciones se pueden o no puede hacer
**RBAC**
- Administrar accesos específicos a los recursos de Azure
- Asignar roles a usuarios, grupos o aplicaciones
**Dónde se puede aplicar**
- Grupos de administración
- Suscripción
- Grupos de recursos
- Recurso individual (Máquinas virtuales)

**Jerarquía y Herencia**
Los permisos se heredan de niveles superiores a inferiores

**Qué puedo hacer con RBAC de Azure**
- Define quien puede hacer qué en qué recursos
- Se aplica a: Usuarios, grupos y aplicaciones
![](Pasted%20image%2020261011130840.png)

![](Pasted%20image%2020261011130933.png)

`IAM`
- Ver quién tiene acceso
- Consultar el ROL asignado
- Conceder o quitar accesos

### Funcionamiento de RBAC
Una asignación de rol define quien puede hacer qué sobre qué recurso
1. **Entidad de seguridad** (Quién)
	1. Es la identidad a la que se le asigna un rol
		1. **Usuario***
		2. **Grupo**
		3. **Entidad de servicio**
	
2. **Definición de Rol** (Qué)
	1. Conjunto de permisos
	2. Determinan qué acciones puede realizar la entidad de seguridad
		1. **Propietario**: Acceso total
		2. **Colaborador**: crear y administrar recursos
		3. **Lector**: Ver recursos
		4. **Administrador de acceso de usuario**: Gestiona permisos
	![](Pasted%20image%2020261011131815.png)

3. **Ámbito** (Dónde)
	1. Nivel al que se aplica el acceso
	2. Define en que parte
		1. **Grupo de administración**: Nivel más alto
		2. **Suscripción**: Contiene grupos de recursos y recursos
		3. **Grupo de recursos**: Conjunto de recursos
		4. **Recurso individual**: VM, BD, app
	![](Pasted%20image%2020261011132413.png)

4. **Asignación de Roles**
	- Proceso de unir: `Quíen - Qué - Dónde`

### Azure RBAC es un Modelo de Permiso
Permiso para ejecutar ciertas acciones concretas
`roles = permisos`
- Los permisos se combinan
- **Conjuntos en cada ROL**
	- `Actions`
	- `NotActions`
- **Permisos Efectivos** = `Actions - NotActions`
![](Pasted%20image%2020261011161343.png)

**Asignación de Denegación**
`deny-delete.bicep`

```
// Crea una asignación de denegación en un grupo de recursos para
// impedir que un usuario específico pueda eliminar recursos, 
// incluso si tiene permisos elevados.

resource denyAssignmet 'Microsoft.Authorization/denyAssignments@2020-10-01' = {
  name: 'no-borrar-recursos'
    properties: {
      permissions: [
      {
        actions: []
        notActions: [
          Microsoft.Resources/suscriptions/resourceGroups/resources/delete'
        ]
      }
      ]
      scope: resourceGroup().id
      principals: [
        {
          id: '<objectID-del-usuario-o-grupo>'
          type: 'User'
        }
      ]
    }
}

//Az deployment group create \
// --resource-group demo-rg \
// --template-file deny-delete.bicep
```

**Creación de un Rol Personalizado**
- Empezar de cero
- Iniciar desde JSON
- Clonar un Rol

```json
{
    "properties": {
        "roleName": "demo-rol-personalizado",
        "description": "demo-rol-personalizado",
        "assignableScopes": [
            "/subscriptions/c7490b98-87c5-4743-94a8-725f0981ef81/resourceGroups/demo"
        ],
        "permissions": [
            {
                "actions": [
                    "*/read"
                    "Microsoft.Security/alerts/read"
                ],
                "notActions": [],
                "dataActions": [],
                "notDataActions": []
            }
        ]
    }
}
```

## ALMACENAMIENTO
### Introducción
- `Blob Storage`

### Azure Storage
Almacenar objetos en la nube Microsoft
- Escalable, seguro y de alta disponibilidad
- Tipos
	- `Table Storage`: NoSQL
	- `Queue Storage`: Colas, mensajería, asíncrona
	- `Blob Storage`: Almacenar grandes cantidades, textos, binarios, etc.

- Tipos (con Máquinas virtuales)
	- `Azure Files`: SMB, NFS
	- `Azure Disk Storage`: Alto rendimiento

### Azure Blob Storage
Almacenar grandes volúmenes de datos
- Cargas de trabajo nativas
- Archivos
- Data Lake
- Computación de alto rendimiento
- IA y Machine Learning

**Escalable, duradero y disponible**
Replicación geográfica
Protegido `RBAC`
Optimizado para lagos de datos
Administración de datos completa: Ciclo de vida de extremo a extremo, control basado en directivas y almacenamiento inmutable `WORM`

**Usos**
- Imágenes
- Streaming
- Logs
- Almacén de datos: backups

**Tipos de Blob**
- **Block**: Cargas masivas de datos. Bloques individuales que se gestionan de forma separada
- **Append**: Bloques optimizados para agregar datos al final. Para `logs` o registros de escritura continua.
- **Page**: Acceso directo a cualquier parte archivo. Lectura y escritura aleatoria.

**Niveles de Acceso**
- **Hot**: Accedidos frecuentemente. Tiempos de acceso más bajo y costos de acceso más altos
- **Cool**: Almacenamiento para datos accedidos ocasionalmente. Menor costo
- **Cold**: Rara vez se accede.
- **Archive**: Datos a los que rara vez se accede. Costos más bajos. Tiempos de recuperación más largos.

**Estructura de Azure Blob**
- `Cuenta de almacenamiento`: Raíz
- `Contenedor`: Organiza los blobs
- `Blob`: El archivo en sí
![](Pasted%20image%2020261024111619.png)

## ALMACENAMIENTO (PT 2)

### Azure Archive Storage
Solución rentable para almacenamiento a largo plazo. Datos raramente accedidos
Movimiento entre niveles de almacenamiento
- Clasificación, búsqueda
- Cifrado

**Características**
- Requerimiento: Por políticas, legislación y recuperación
- Precios más bajos
- Características: Duradero, cifrado, estable. Datos que se acceden con poca frecuencia
- Liberar almacenamiento: Liberar on premises
- Seguro: financiero, datos médicos
- Blob: Almacenamiento Blob, tiene las mismas herramientas

![](Pasted%20image%2020261101162242.png)

### Redundancia de Almacenamiento
Datos disponibles con copias.
Siempre crea múltiples copias de nuestros datos, es invisible para el usuario final
- Zona única, múltiples zonas, múltiples regiones

**Región Única**
`LRS` y `ZRS`

**Múltiples regiones**
`GRS` y `GZRS`

Todas las opciones incluyen:
- Tres copias en la region primaria
- Tres copias en la región secundaria (Para opciones de múltiples regiones)

#### Almacenamiento con redundancia local LRS
Crea automáticamente 3 copias en la región primaria para garantizar su durabilidad
- Más económica
- Proteger datos contra fallos en el hardware
- Todo dentro de una única región
- No ofrece protección contra interrupciones de zona o regionales

#### Almacenamiento con redundancia de zona ZRS
- Replica datos en diferentes zonas de disponibilidad dentro de una misma región
- Mantiene 3 copias
- Salvaguardar los datos incluso si una zona completa enfrenta problemas
- Costo más alto
- No protege catástrofes que afecten regiones completas

#### Almacenamiento con redundancia geográfica GRS
- Replica datos en diferentes centro de de datos en regiones geográficamente separadas
- Mantiene 3 copias en la región primaria y 3 en una secundaria
- Alta disponibilidad
- Costo superior
- Ideal para quienes necesiten el más alto nivel de protección y disponibilidad

#### Almacenamiento con redundancia de zonas geográficas GZRS
- `ZRS` + ` GRS`
- 3 copias de datos distribuidas en diferentes zonas de disponibilidad en la región primaria `ZRS`
- 3 copias adicionales en una región secundaria `LRS`
![](Pasted%20image%2020261101164106.png)

### Almacenamiento Premium
Requisitos de baja latencia
**Tipos** de almacenamiento
Opciones de redundancia

- **Standard**
	- Soporta todos los tipos de almacenamiento y opciones de redundancia
	- **Premium**
		- Blobs en bloques `Premium block blobs` Rendimiento superior
			- Altas tasas de transacciones
		- Recursos compartidos de archivos `Premium file shares` Comparticiones de archivos de rendimiento optimizado para operaciones de archivo más rápida y eficiente
			- Aplicaciones empresariales que necesitan escalarse
		- Blobs de páginas `Premium page Blobs`: Blobs de página con un rendimiento más elevado, adecuado para cargas de trabajo intensivas
			- Operaciones de lectura y escritura aleatorias

#### Block blobs
Ideal para cargas de trabajo de almacenamiento blob de baja latencia
`AI` o `IoT`
- **Redundancia** soporta redundancia local `LRS` y `ZRS`
- Aplicaciones que necesitan un acceso rápido y un tiempo de respuesta bajo. Tareas críticas y operaciones intensivas

#### Premium File Shares
Alto rendimiento
**Protocolos**
- `SMB` y `NFS`
- `Windows` y `Linux`

**Redundancia**
- `LRS` y `ZRS`

#### Page Blobs
Usado para discos virtuales no gestionados
**Redundancia**
`LRS` y `ZRS`
Útiles para escenarios que requieren `I/O` aleatorio, como bases de datos y discos de máquinas virtuales

![](Pasted%20image%2020261101172156.png)

### Movimiento de Datos
Criterios
- Frecuencia de transferencia
- Tamaño de datos
- Ancho de banda de la red

**Herramientas**
**AzCopy**
Para copiar datos hacia y desde servicios de almacenamiento de Azure
```bash
# Transferir archivos
azcopy

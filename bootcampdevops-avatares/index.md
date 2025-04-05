+++
date = '2025-01-16T14:09:17-05:00'
title = 'Código Facilito | BootCamp DevOps | Proyecto Final | Avatares'
+++

## Objetivos
- Aplicar los conocimientos adquiridos durante el
Bootcamp
- Iniciar o adicionar el proyecto a nuestro portafolio
- Desarrollar un proyecto que reflejen situaciones reales, nos
enfrentamos a desafíos auténticos, lo que nos prepara mejor para
el entorno laboral
- Podernos graduar del Bootcamp

## Información del Proyecto
- **Integrante**: Rodrigo Silva Alegría
- **Repositorio**: https://github.com/rodosilva/bootCampDevOps-ProyectoFinal-Avatares
- **Video Presentación**: https://youtu.be/K8x0AuKe_G8?si=2_lelJRPRRDKBUcB
> **_NOTA_**
> *Este proyecto utiliza como base la aplicación de `Rossana Suarez` la cual podremos encontrar en [gitlab](https://gitlab.com/training-devops-cf/avatares-devops)*

## Descripción
Este proyecto podría definirse en 5 fases.

**La primera fase** se basa en la construcción y ejecución de 2 contenedores. Uno de ellos con el backend (API) y el otro con el frontend (WEB). Todo orquestado con `Docker Compose`

La fase termina en cuanto se muestra el correcto funcionamiento de la aplicación desde el `http://localhost:5173`

**La segunda fase** se basa en la integración continua `CI`, lo que se traduce en el `push` de las imágenes hacia [Docker Hub](https://hub.docker.com/r/rodosilva/). Esto se logra gracias a los `jobs` de nuestro `Github Actions` 

**La tercera fase** se basa en la construcción de la infraestructura en `AWS`. La cual contendrá tanto el `VPC` como el cluster `EKS` (Kubernetes). Esto se logra utilizando `Terraform`

**La cuarta fase** se basa en la creación de los manifiestos de `Kubernetes` tales como los `deployments`, `configmaps` y `services` para el correcto funcionamiento de la aplicación pero esta vez alojada en `AWS`.

**La quinta fase** y fase final, se basa en la creación de los manifiestos necesarios para todo lo referente al monitoreo de la mano de `Prometheus` y `Grafana`

## Puesta en Marcha

### 1. Docker Compose: Despliegue local de la aplicación

En este directorio `./backFront/` se encuentra el único script que necesitamos ejecutar para poder correr la aplicación de `Avatares` de forma local dentro de contenedores (Usando `Docker Compose`).

El script `runCompose.sh` realizará los pasos necesarios para poner en marcha la aplicación.

#### Descripción de los Archivos
- `runCompose.sh`: Script que pone en marcha tanto el contenedor API (backend) como el WEB (frontend) usando Docker Compose.

- `.compose.env`: Archivo que contiene las variables como las variables de entorno el cual es llamando durante la ejecución mediante `source`

- `docker-compose.yaml`: Archivo con las instrucciones adecuadas para construir ambos contenedores junto a las condiciones necesarias para su comunicación y buen funcionamiento.

#### Requisitos
Para poder ejecutar vamos a necesitar:
- **Docker Compose**: Preferible v2.30.0
- **Docker**: Preferible version 27.2.1
- **Git**: Preferible version 2.43.0
- **Bash**: Terminal con Bash

#### Pasos
##### 1.1 Clonaremos el repositorio en una carpeta local
```bash
git clone https://github.com/rodosilva/bootCampDevOps-ProyectoFinal-Avatares.git
```
Para luego ingresar al directorio
```bash
cd bootCampDevOps-ProyectoFinal-Avatares/backFront/
```

##### 1.2 Ejecutaremos el script `runCompose.sh`
```bash
./runCompose.sh
```
Este script realiza básicamente 3 pasos. El primero tiene que ver con las variables de entorno, el segundo es ejecutar un par de scripts para crear las carpetas temporales `tempDir` y el tercero es correr el `Docker Compose`

##### 1.3 Disfrutar de la Aplicación
Desde el `localhost` ya nos será posible de visualizar la aplicación.
Tan solo necesitamos ir a la URL:
[Avatares localhost](http://localhost:5173)

![Avatares_Contenedores](Avatares_Contenedores.jpg)
> **_Imagen 1_**:
> Aplicación `Avatares` corriendo de forma local. En la parte superior se logra ver 2 contenedores (backend y frontend) corriendo.

### 2. Github Actions: Push al container registry Docker Hub
Para que este procedimiento presente una forma de integración continua (CI), añadí un `job` a modo de `workflow`.
El cual puede encontrarse en `.github/workflows/pushDockerHub.yaml`

Dicho `Github actions` seguirá una serie de pasos apenas se realice un `push a main`

#### Pasos
##### 2.1 Push a main
Luego de realizar los commits que se vean convenientes, podremos ejecutar:
```bash
$ git push origin main
```
Automáticamente empezarán a correr los `steps` en donde encontramos:
- Autenticación co `Docker Hub`
- Obtención de las variables de entorno necesarias
- Y la construcción y envío de las imágenes

![jobs](gigthubActitions_Jobs.PNG)
> **_Imagen 2_**: Job y steps del workflow (Github Actions)

![dockerHub](dockerHub.PNG)
> **_Imagen 3_**: Podemos ver las imágenes ya subidas al Docker Hub

### 3. Terraform: Infraestructura como código en AWS
En esta fase se construirá la infraestructura en AWS base para poder albergar nuestras imágenes y poder apreciar la aplicación `Avatares`

Nos ubicaremos en el directorio `./terraform-EKS/`

#### Descripción de Archivos
- `provider.tf`: En este archivo encontraremos los `locals` o variables que necesitaremos durante el proceso, como también el proveedor y región que en este caso será `AWS us-east-1`

- `vpc.tf`: Archivo encargado de dar las instrucciones para la construcción de la red o `VPC` que albergará y promoverá la comunicación entre los servicios.

- `eks.tf`: Archivo encargado de la construcción del cluster de `EKS` que viene a ser un `Kubernetes` desde `AWS`

#### Requisitos
- **Terraform**: Preferible v1.10.4
- **aws-cli**: Preferible versión 2.23.1

#### Pasos

##### 3.1 Configurando aws-cli y creando el rol EKS
El primer paso es obtener las claves de acceso del `IAM User`
También se pueden crear desde la consola de `AWS`

Cuando ya las tengamos deberemos añadirlas desde nuestra consola:
```bash
$ aws configure
AWS Access Key ID [****************]: 
AWS Secret Access Key [****************]:
Default region name [us-east-1]: 
Default output format [None]:
```

También deberemos colocar el ARN:
`arn:aws:iam::536697240563:role/avataresEksClusterRole` en el archivo `eks.tf`
Ese rol se debe crear desde la consola en `IAM - Roles` y elegir la opción `EKS CLuster`[¹]

[¹]: Para no incurrir en sobre costos, durante las pruebas usé un `Playground` de la plataforma de `KodeKloud`. Dicho sandbox se destruye luego de 3 horas y los permisos son limitados. Es por ellos de dicho `arn` ha sido temporal y a modo de ejemplo. Una vez que pasé la fase de pruebas, empecé a utilizar mi propia cuenta de `AWS` 

##### 3.2 Inicializando Terraform
Ahora toca inicializar el `Terraform`.
Esto hará que se descarguen todos los archivos necesarios para el funcionamiento del proveedor que en este caso es `AWS`
```bash
$ terraform init
```

##### 3.3 Planificando los cambios en la infraestructura
Luego de validar posibles errores de escritura o de indentación con
```bash
$ terraform validate
```
Podremos planificar los cambios que `Terraform` desea realizar
```bash
$ terraform plan
```

##### 3.4 Aplicando los cambios en la infraestructura
Finalmente nos preparamos para aplicar los cambios con
```bash
$ terraform apply
```
No olvidemos de destruir la infraestructura una vez hayamos terminado para evitar cobros adicionales
```bash
$ terraform destroy
```

### 4. Kubernetes Deployments: Despliegue de la aplicación
Ya tenemos el `EKS Cluster` corriendo.
![eksCluster](./eksCluster.png)
> **_Imagen 4_**: Estado del cluster visto desde la consola 

Es momento de desplegar los manifiestos de `Kubernetes` para el correcto funcionamiento de la aplicación `Avatares` desde la nube de `AWS`

Para ello deberemos empezar por explorar la carpeta `./eks`

#### Descripción de archivos
- **deploymentAvataresBack.yaml | deploymentAvataresFront.yaml**: Archivos encargados de desplegar tantos `pods` como se haya especificado. Los cuales contienen a los contenedores con los que hemos venido trabajando hasta el momento.

- **serviceAvataresBack.yaml | serviceAvataresFront.yaml**: Estos archivos están encargados de brindar aspectos de red y conectividad con los `pods`. En el caso del `back` a modo de `clusterIP` y para el caso del `front` a modo de balanceador de carga.

- **configMapAvataresBack.yaml | configMapAvataresFront.yaml**: Estos archivos presentan aspectos de configuración para los `pods`. En este caso he colocado las variables de entorno necesarias para el buen funcionamiento de la aplicación.

- **k8sDeployment.sh**: Este archivo es un breve script encargado de desplegar todos los manifiestos para simplificar la ejecución.

- ***aws-auth-cm.yaml**: [²]

[²]: Este archivo está relacionado con los pasos específicos que tiene el `Playground` de `KodeKloud` para el despliegue del `Eks Cluster`. Dicho `configMap` se encarga de las configuraciones para unir los `worker nodes` con el cluster.
Cuando empecé a utilizar mi propia cuenta de `aws` dicho archivo se dejó de utilizar

#### Requisitos
- **kubectl**: Preferible versión 1.31.5

#### Pasos
#### 4.1 Conectar nuestro kubectl al api de aws
Para poder utilizar nuestros comandos `kubectl` de forma local. Deberemos establecer conexión con el cluster `EKS`.
```bash
$ aws eks update-kubeconfig --region us-east-1 --name avatares-cluster
```

#### 4.2 Ejecutar el script que corre los manifiestos de k8s
Nos colocamos en:
```bash
$ cd eks/
```
Ejecutamos el script
```bash
$ ./k8sDeployment.sh
===========================
Despliegue de los ConfigMap
===========================
configmap/configmap-avatares-back created
configmap/configmap-avatares-front created
=============================
Despliegue de los Deployments
=============================
deployment.apps/deployment-avatares-back created
deployment.apps/deployment-avatares-front created
===========================
Despliegue de los Services
===========================
service/avatares-back created
service/avatares-front created
==============================================
Mostrando URL del LoadBalancer para ver la APP
==============================================
La URL es: http://a2a70d6aa0cc54c6f80d784e5238dc85-204900509.us-east-1.elb.amazonaws.com:5173/
```
Con esto estaremos desplegando `deployments`, `configMaps` y `services` necesarios para el correcto funcionamiento de la aplicación `Avatares`

![diagrama](./k8sDiagrama.jpg)
> **_Imagen 5_**: Diagrama simplificado de los recursos k8s

#### 4.3 Visualizar la aplicación desde el endpoint del balanceador de carga
Al final el mismo script entregará una URL muy parecida a esta:
`http://a2a70d6aa0cc54c6f80d784e5238dc85-204900509.us-east-1.elb.amazonaws.com:5173/`

Ahí podremos observar la aplicación en total funcionamiento:
![avataresLoadBalancer](./avataresLoadBalancer.png) [³]
> **_Imagen 6_**: Aplicación Avatares vista desde URL externa

[³]: Por alguna razón al momento de grabar el video, tuve que realizar un cambio al archivo `vite.config.js`. Algo que no había sido necesario durante las pruebas anteriores. Tuve que añadir el endpoint del load balancer a dicho archivo de esta forma: `allowedHosts: ["a6b0cefb684f248388f815255406f89f-43795873.us-east-1.elb.amazonaws.com"],`

### 5. Prometheus & Grafana: Monitorizando los Recursos de Kubernetes
Ya tenemos a la aplicación de `Avatares` desplegada en `Kubernetes` y observable desde una URL externa.

Es momento de monitorear. Para ello utilizaremos `Prometheus` para la obtención de métricas y `Grafana` para tener una interfaz de usuario más amigable.

#### Requisitos
- **Helm**: Preferible v3.16.3

#### Pasos
##### 5.1 Añadir el repositorio de prometheus-community
Antes que nada, deberemos añadir de forma local el repositorio de `prometheus-community` y así tener los recursos necesarios para el despliegue que viene en el siguiente paso.
```bash
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

##### 5.2 Desplegar Prometheus y Grafana en nuestro cluster
Ahora desplegamos los recursos necesarios para la correcta ejecución de `Prometheus` y `Grafana` en nuestro cluster
```bash
$ helm install prometheus-stack prometheus-community/kube-prometheus-stack --namespace=monitoring --create-namespace
```

**_Opcional_**:
Si quisiéramos tener el template de forma local podríamos usar el siguiente comando:
```bash
$ helm template prometheus-stack prometheus-community/kube-prometheus-stack --namespace=monitoring --create-namespace > prometheus-stack.yaml
```

##### 5.3 Editar el servicio de Grafana para poder entrar de forma externa
Este paquete de la comunidad por defecto no genera una URL externa para que podamos ingresar a `Grafana`

Para ello deberemos editar el servicio
```bash
$ kubectl edit service -n monitoring prometheus-stack-grafana
```
Dado que para este laboratorio no estamos usando certificado, también cambiaremos el puerto `80` por por ejemplo el `5270`
```
[...]
  ports:
  - name: http-web
    port: 5270
    protocol: TCP
    targetPort: 3000
  selector:
    app.kubernetes.io/instance: prometheus-stack
    app.kubernetes.io/name: grafana
  sessionAffinity: None
  type: LoadBalancer
[...]
```

##### 5.4 Ingresando a Grafana
Finalmente ya podemos ingresar a `Grafana`.
Para ello revisaremos la URL se muestra desde el servicio:
```bash
kubectl get services -n monitoring
```

E ingresaremos a una URL my parecida a esta:
`http://:5270`

Dado que hemos usado los valores por defecto del paquete de `prometheus-community/kube-prometheus-stack`, las credenciales para ingresar son:
```
Usuario: admin
Password: prom-operator
```

**_Opcional:_**
Si quisiéramos obtener dichos valores por defecto, podemos revisar el archivo de la siguiente forma:
```bash
$ helm show values prometheus-community/kube-prometheus-stack > prometheus-default-values.yaml
```

Hemos llegado al final, `Grafana` cuenta con sus plantillas. En nuestro caso utilizaremos la de `Kubernetes - Pods` con lo que podemos ver las métricas en forma gráfica:
![grafana_back](./grafana_AvataresBack.png)
> **_Imagen 7_**: UI Grafana revisando el Pod de Avatares-back

![grafana_front](./grafana_AvataresFront.png)
> **_Imagen 8_**: UI Grafana revisando el Pod de Avatares-front

## Palabras Finales
Este proyecto es un vistazo breve del ciclo de vida de una aplicación.
Desde su despliegue de forma local, hasta llegar a su habitad en la nube.

Siempre existirán opciones de mejora, y este proyecto no es la excepción.
La idea es mantener este proyecto vivo e ir mejorándose y automatizándose. 



+++
date = '2025-09-20T12:42:11-05:00'
title = 'DevOps GitOps & CloudOps'
+++

## DevOps

### Prueba de Integración
Para poder entender qué es una prueba de integración o `Integration Testing`, primero debes conocer lo que es una `Unit Testing`.

`Unit Testing` es una prueba realizada al código de una aplicación. Pero esta se aplica solamente a una unidad en particular. Es decir es una prueba aislada a un módulo o unidad del programa en general.

Ahora `Integration Testing` sería el siguiente paso. Una o varias pruebas que se basan en la funcionalidad en conjunto de la suma de las unidades, asegurando la funcionalidad de mismas trabajando juntas.

#### Aproximación Big Ban
Se basa en verificar todos los módulos en una, luego de completar la revisión individual de cada módulo. 
#### Aproximación Top Down and Bottom Up
Se basa en el uso de `dummy modules` para simular data que fluye entre módulos.
### CI/CD Conceptos Y Alcances
Es un flujo de trabajo automatizado `DevOps` que agiliza los procesos de entrega de software.

#### CI: Integración continua
Automáticamente construye, prueba e integra cambios en el código dentro de repositorios compartidos.
El alcance de este etapa suele llegar hasta la entrega del artefacto o binario.

#### CD: Entrega continua
Entrega automáticamente código a entornos tipo `Stage` (Listo para producción). Y queda a la espera de alguna aprobación posiblemente manual.
El alcance de esta etapa suele llegar hasta la entrega del artefacto a algún repositorio tipo `Docker Hub` o `Artifactory`

#### Despliegue continuo (Continuous Deployment)
la parte `CD` de `CI/CD` suele hacer referencia a la entrega continua. En cambio el despliegue continuo suele tener algún paso manual de aprobación. Puesto que esto ya es un pase a producción (A veces puede hacer referencia a un pase a servidores de`testing`).

### Estrategias de Git Branching
Las estrategias de Git branching son como rutas o caminos que usan para organizar el trabajo, hacer seguimiento a las versiones y lograr un trabajo conjunto en el trabajo de control de versiones.

#### Trunk-Based Development
Puede darse casos de `commit` que van directo a la rama `main`, o ramas pequeñas creadas específicas para algo en particular que son `merged` rápidamente.
Presenta ramas de corta vida como: `/task/{{id}}` o `/fix/1234`

![](Pasted%20image%2020250921093921.png)

- Escenarios de CI/CD
- Equipos ágiles
- Cierto riesgo de inestabilidad
- Se requiere disciplina y una buena revisión de código

#### Feature Branching
Cada prestación o `Bug fix` se desarrolla en su propia rama. Una vez completado el desarrollo se une a la rama `main`

![](Pasted%20image%2020250921094929.png)
- Equipos que necesitan tener las prestaciones claras
- Minimiza el peligro a romper producción
- Necesita una constante actualización de las ramas
- Puede presentar conflictos de `merge`

#### Release Branching
Ramas separadas que se mantienen para cada `release` versión.
![](Pasted%20image%2020250921095839.png)
- Se usa en proyectos con soporte de largo plazo (LTS)
- Brinda un historial claro de cada `release`.
- Difícil manejo de ramas
- No ideal para proyectos que requiera velocidad.
- Se suele usar para proyectos con pocos `deployments`

#### Github Flow
Es un flujo simplificado para ser orientado hacia la entrega continua.
Se basa en ramas `feature` de corta vida que luego son integradas a la rama `main`.
![](Pasted%20image%2020250921111621.png)
- Se suele utilizar en equipos que quieren integrar CI/CD
- Proyectos cortos de alta velocidad
- Puede presentar inestabilidad, dado que la rama `main` debe estar siempre lista para producción.
#### GitFlow
Es una estrategia sumamente estructurada que utiliza multiples ramas como `main`, `develop`, `feature`, `release` y `hotfix`.
Requiere un buen uso del `naming convention` para las ramas: 
- Feature: `/feature/{{author}}/{{card-number}}/{{short-description}}`
- Hotfix: `/hotfix/{{issue-number}}`
- Release: `/release/{{version}}`

![](Pasted%20image%2020250921101152.png)
- Proyectos grandes y complejos que requieren mucha estabilidad.
- Los roles y las responsabilidades están bien definidas.
- Presenta complejidad y requiere un fuerte seguimiento de reglas
- No es ideal para necesidades de despliegue continuo.

#### Environment Branching
Es parecida a la **GitFlow** con la característica de tener una rama para cada entorno como`production`, `stage`, `dev`. Y a su vez también tiene los `release branches`, etc.
- Asume que necesitamos una rama para cada entorno
- 
### Estrategias de Despliegue
Se basa en las formas del pase a producción de nuestro código.

#### Big Bang Deployment
El pase se basa básicamente en apagar un sistema para luego prender la nueva versión.
Presenta complicaciones en caso se de alguna falla durante o luego del pase. Por lo que se tendría que hacer `rollback`.
Necesita tener un buen plan de `rollback`.

#### Rolling Deployment
El cambio se da de forma incremental con el tiempo.
![](Pasted%20image%2020250921114018.png)

El despliegue de la nueva versión se da gradualmente por lo que se va actualizando un server a la vez.
Usualmente previene caídas de servicio para los usuarios. Sin embargo no permite realizar `targeted Rollouts` hacia un grupo específico de usuarios.

#### Blue-Green Deployment
Se basa en tener dos sistemas idénticos, el `Blue` y el `Green`.
![](Pasted%20image%2020250921115006.png)
El `Blue` suele estar como activo, mientras que el `green`, como inactivo.

El `Green` termina siendo como nuestro `playground` donde se puede desplegar y probar las nuevas versiones. Los colaboradores de `Q&A` suelen apuntar siempre al `Green`.

Cuando `Green` se considera como listo, se hace que todos los usuarios apunten a este entorno. Es decir `Green`pasa a ser el activo.

Ahora el `Blue` pasa a estar inactivo y termina siendo un entorno de respaldo.

No se suele poder dirigir a un grupo específico de usuarios hacia la nueva versión una vez hecho el cambio. Además es una infraestructura compleja que consume muchos recursos.

#### Canary Deployment
Se basa en probar la nueva versión pero de una forma gradual y controlada.
Ejemplo: `Rolled Out al 10%`
Puede ser ir cambiando la versión de los servidores poco a poco, como también ir desviando a cierto grupo de usuarios para tener un entorno de producción pero a una escala menor.
![](Pasted%20image%2020250921120656.png)
En caso de falla simplemente se puede volver a desviar a los usuarios de regreso al grupo de servidores anterior. Es decir este método si permite `Targeted Rollouts` con lo que se puede usar diferentes criterios de selección como localización geográfica o tipo de dispositivos.

Sí requiere herramientas complejas de infraestructura como monitoreo y pruebas automatizadas.

`Canary Deployment` se suele utilizar en conjunto con otras estrategias de despliegue como por ejemplo `Rolling Deployment`

#### Feature Toggle
No se basa necesariamente en pasar toda la aplicación a una nueva versión.
Sino más bien, manejar prestaciones específicas dentro de la aplicación.

![](Pasted%20image%2020250921122048.png)

Entonces se puede prender o apagar ciertas `features` a disposición para ciertos usuarios o bajo ciertas circunstancias.

También puede ser usado en combinación con cualquier otra estrategia de despliegue.

Ofrece mucho control sobre quien puede acceder a esas nuevas `features`. Es decir permite el `Targeted user testing` o `A/B testing`

## GitOps
`GitOps` toma las prácticas de `DevOps` y las aplica a la automatización de infraestructura (Infrastructure as a Code).

Entonces diferentes colaboradores puede hacer `Push` desde los repositorios hacia la infraestructura para así realizar cambios en ella bajo una especie de control de versiones.

Pero así como hay un `Push` también existe un `Pull`. Que está constantemente leyendo la infraestructura para poder compararla con lo que se tiene el los repositorios.

![](Pasted%20image%2020250920162206.png)

Y gracias a herramientas tales como `ArgoCD`, se consigue que `Git` sea la fuente de la verdad (source of truth). 
Esto significa que `ArgoCD` es capaz de detectar cualquier cambio en la infraestructura (algún posible cambio manual) y si esta es diferente al repositorio de `git`, lo revierte nuevamente tal y como está definido en el repositorio. 

## CloudOps

### IAM
#### IAM Policies
Documentos Json que pueden ser asignados a usuarios o grupos
#### IAM Roles
- Servicios AWS realizando acciones a tu nombre.
- Asignar permisos a servicios AWS con `IAM roles`

### EC2
Infraestructura como servicio. 
- EC2 maquinas virtuales
- EBS Almacenamiento o discos virtuales
- ELB Distribución de carga
- ASG Escalamiento de servicios `auto-scaling group`

#### EC2 Instance Store
- Disco de alta performance. 
- Mejor I/O, bueno para buffer, cache, etc
#### Security Groups
- Controlan como el tráfico es permitido hacia adentro o hacia afuera de las EC2
- Solo tiene reglas `allow`

### Almacenamiento
#### EBS
Disco de red que puede ser conectado y desconectado de un EC2 con facilidad.
- EBS snapshots
- EBS encriptación
- Puede conectarse a solo una instancia a la vez

#### EFS
- NFS administrable que puede ser montado en varios EC2
- Solo para Linux

#### AMI
- Imagen de Amazon.

### Alta Disponibilidad Y Escalabilidad ELB & ASG
#### ELB Elastic Load Balancing
- Reenvío de tráfico a multiples servidores
- Expone un solo punto de acceso (DNS)
- SSL/TLS
- Tipos
	- Classic CLB
	- Aplicación ALB (capa 7)
	- Red NLB (Capa 4) - Menos latencia
	- Gateway GWLB

#### Auto Scaling Group
- La carga en tus webs puede cambiar
- Puede crear o eliminar servidores
- Scale Out: Añade EC2
- Scale In: Elimina EC2
- Políticas de escalamiento: e.g Promedio de uso de CPU.

### RDS
Bases de datos relacionales
- Postgres, MySQL, MariaDB, Oracle, SQL, Aurora
- Auto scaling
- RDS Read Replicas

#### Aurora
Propiedad de AWS
- Aurora Serverless
- Global Aurora

#### Amazon RDS Proxy
Base de datos Proxy para RDS
- Mejora la eficiencia

#### Amazon ElastiCache
- Bases de datos de cache en memoria
- Baja latencia, alta performance
- Cargas de lectura intensa
- Redis Vs Memcached
![](Pasted%20image%2020250921174544.png)

### Route 53
Traduce nombres amigables al ojo humano en direcciones IP
- Domain registrar: Amazon Route 53, GoDaddy, etc
- DNS Records
- Zone
- Name Server: Resuelve consultas DNS
- TLD: .com
- SLD: amazon.com
- CNAME Vs Alias: CNAME es Hostname que apunta a otro hostname y no pueden ser dominios raíz. Alias es hostname que apunta a algún recurso AWS.

#### Políticas de Enrutamiento
Define como Route 53 responde a las consultas DNS
- Simple: Enruta hacia un recurso
- Weighted: Controla el % de las solicitudes
- Failover: Active Passive. 
- Latency Based: Enruta hacia recursos que tengan la menor latencia
- Geo localización: Basado en la ubicación del usuario
- Multi_Value Answer: Enrutar a varios recursos
- Geoproximity: Basado en la geografía de usuarios y recursos

#### Health Checks
Monitorean un endpoint
- Protocolos: HTTP, HTTPS, TCP

### Amazon S3
Almacenamiento de objetos en buckets
- Versioning
- Lifecycle Rules
#### S3 Security
- User based: con IAM policies
- Resource based: Bucket policies
- Encriptación

#### Storage Classes
- Standard, Standard Infrequent Access, One zone IA, Glacier, Glacier Flexible, Glacier Deep Archive, Intelligent Tiering

### AWS CloudFront
Content Delivery Network
- Mejora la lectura, el contenido esta en cache en el edge
- Protección DDoS

### Storage Extra
#### Amazon FSx
File systems de alta performance
- FSx for Windows
- FSx for Lustre: Para alta escala

### SQS, SNS, Kinesis, Active MQ
Aplicaciones que se comunican entre ellas
#### Amazon SQS
El mensaje persiste en SQS hasta que sea consumido por el consumidor (lo borra)
- Consumidores: EC2, serverless, lambda
- FIFO Queue

#### Amazon SNS
Un mensaje hacia varios receptores
![](Pasted%20image%2020250921184539.png)

- SNS + SQS: Fan Out
- Amazon SNS FIFO Topic

#### Kinesis
Colecta, procesa y analiza data en tiempo real
- Kinesis Data Firehose

### Contenedores en AWS: ECS, Fargate, ECR y EKS

#### Amazon ECS
Lanza contenedores Docker en AWS
- ECS - EC2 (Dentro de una instancia)
![](Pasted%20image%2020250921185204.png)

- ECS - Fargate: Serverless
- ECS puede usar EFS

#### ECR
Elastic container registry
- Sirve para almacenar imagenes Docker en AWS

#### Amazon EKS
Amazon Elastic Kubernetes Service
- EC2 si quieres worker nodes como instancias
- Fargate: Solución serverless

### Serverless
Solo despliegue de código
![](Pasted%20image%2020250921190011.png)

- Por qué AWS Lambda
![](Pasted%20image%2020250921190124.png)

#### API Gateway
- Lambda + Api gateway = No hay infraestructura que manejar
- Expone cualquier AWS PI con API Gateway

#### Amazon Cognito
Entrega a los usuarios una identidad para con nuestra web o aplicación
![](Pasted%20image%2020250921190903.png)

### Data Y Analítica
- Amazon Athena
- Amazon Redshift
- Amazon OpenSearch
- Amazon EMR
- Amazon QuickSight
- AWS Glue
- AWS Lake Formation
- Kinesis Data Analytics
- Amazon Managed Streaming for Apache Kafka
- Big Data Ingestion Pipeline

### Machine Learning
- Amazon Rekognition
- Amazon Transcribe
- Amazon Polly
- Amazon Translate
- Amazon Lex & Connect
- Amazon Comprehend
- Amazon Comprehend Medical
- Amazon SageMaker
- Amazon Forecast
- Amazon Kendra
- Amazon Personalize
- Amazon Textract

### AWS Monitoring and Audit: CloudWatch, CloudTrail & Config

#### Amazon CloudWatch
Entrega métricas
- Metric stream
- CloudWatch Logs
- CloudWatch Agent y Logs Agent
- CloudWatch Container Insights: Colecta y resume métricas y logs de contenedores
- CloudWatch Lambda Insights: Solución para serverless

#### Amazon EventBridge
![](Pasted%20image%2020250921191837.png)

#### AWS CloudTrail
Governance y compliance y auditoria para cuentas AWS
![](Pasted%20image%2020250921192206.png)

#### AWS Config
Ayuda a las auditorias.

### IAM Advanced
- AWS Control Tower: Multi-Account

#### AWS Directory Services
- AWS Managed Microsoft AD: Establece confianza con AD on-premise
- AD Connector: Gateway (Proxy) que redirige a un AD on-premise
- Simple AD: AD compatible

#### IAM Identity Center - Active Directory Setup
Conexión con un Microsoft AD manejado por AWS
![](Pasted%20image%2020250921201040.png)

### AWS Security & Encyption KMS, SSM Parameter Store, CloudHSM, Shield, WAF
- KMS: Manejo de llaves
- SSM Parameter Store: Manejo de Secrets
- AWS Secret Manager: Rotación de Secrets
- AWS Certificate Manager ACM: Manejo de certificados TLS
- WAF: Firewall
- AWS Shield
- Amazon GuardDuty
- Amazon Inspector
- Amazon Macie

### Networking VPC
Virtual Private Cloud
![](Pasted%20image%2020250921201837.png)

#### Internet Gateway IGW
Permite que los recursos dentro de un VPC, se conecten con el internet
![](Pasted%20image%2020250921202200.png)

#### Bastion Hosts
Bastion está en una subnet pública que a su vez se puede conectar con las subnets privadas.

#### NAT Gateway
![](Pasted%20image%2020250921202643.png)

#### Security Groups & NACLs
Network access control list
- Control de tráfico
- Security Group es a nivel de instancia
- NACL es a nivel de subnet

#### VPC Peering
Conexión privada entre VPC

#### VPC Endpoints
Te permite conectarte con un servicio AWS usando una red privada en lugar de una pública.
![](Pasted%20image%2020250921203502.png)

- Interface Endpoint
- Gateway Endpoint

#### AWS Site to Site VPN
- AWS VPN CloudHub: Si tienes multiples conexiones VPN

#### Direct Connect DX
Conexión privada desde una red remota hacia tu VPC

#### Transit Gateway
Hub and spoke connection entre VPCs

### CloudFormation
Despliegue y manejo de infraestructura. IaC
- Forma declarativa



## SysAdmin



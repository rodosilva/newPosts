+++
date = '2026-02-18T21:00:51-05:00'
title = 'Docker Runtime'
+++

## TEMARIO
**Temario Docker Runtime**
**Nivel: Básico**

- **Introducción**
	- Requisitos y qué necesitaremos
	- ¿Qué es un Runtime y por qué Docker?
	- Instalación y "Hello World"
	- Laboratorio: Revisando el ciclo de vida de un contenedor
- **Arquitectura de Docker**
	- Docker Engine
	- Imágenes Vs Contenedores
	- Registry
	- Layers Vs Copy-on-Write
	- Namespaces y cgroups
- **Almacenamiento**
	- Volúmenes
	- Bind Mounts
	- Laboratorio: Crear un contenedor donde la data sea persistente
- **Redes y Conectividad**
	- Mapeo de Puertos: Publicando servicios al exterior
	- Redes Bridge: Comunicación entre contenedores
	- Laboratorio: Revisando la comunicación entre dos contenedores
- **Contenedores**
	- Arranque automático
	- Laboratorio: Reiniciar la máquina local y observar el inicio automático del contenedor
- **Imágenes**
	- Pull y Push
	- Tags y versionado
	- Docker Hub y registries privados
- **Dockerfile**
	- Instrucciones: FROM, RUN, WORKDIR, COPY, CMD
	- Argumentos y Variables de Entorno
	- Secrets
	- Laboratorio: Crear nuestro Dockerfile y ver diferencias entre argumentos y variables de entorno
- **Docker Compose**
	- Estructura del archivo
	- Servicios, redes y volúmenes
	- Dependencias entre contenedores
- **Limpiando el Espacio de Trabajo**
- **Laboratorio: Proyecto Final**


## DESARROLLO
### 1. Introducción
#### Requisitos y Qué Necesitaremos
Conocimiento básico de línea de comando en el shell de Linux
Necesitaremos una máquina con cualquier distribución de Linux. En mi caso utilizaré `Ubuntu 24.04`
#### ¿Qué es un Runtime y Por Qué Docker?
`Runtime` es un componente de software responsable de correr contenedores.
Docker nos permite separar nuestras aplicaciones de la infraestructura para entregar software de forma más rápida.
Además nos da la habilidad de correr aplicaciones en un entorno aislado llamado contenedor. Quien contiene todo lo necesario para correr dicha aplicación.

#### Instalación y "Hello World"
Configuramos el repositorio de `Docker`
```bash
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
```

Instalamos la última versión:
```bash
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Verificamos la instalación y corremos la aplicación "Hello World"
```bash
sudo docker run hello-world
```

Finalmente, creamos el grupo `Docker`
```bash
sudo groupadd docker
```

Y añadimos nuestro usuario a dicho grupo
```bash
sudo usermod -aG docker $USER
```

### 2. Arquitectura de Docker
#### Docker Engine
Es una tecnología de contenedores para crear nuestras aplicaciones. `Docker Engine` funciona como una aplicación cliente-servidor que cuenta con:
- Un server con un proceso `daemon` : `dockerd`
- APIs
- Interfaz de línea de comando `CLI`
![](Pasted%20image%2020260301204029.png)

#### Imágenes Vs Contenedores
Una imagen contiene el código de la aplicación, dependencias y configuraciones. Se usan como un `blueprint` para crear los contenedores. Y se puede reutilizar para crear múltiples contenedores.

Las imágenes se suelen construir a base de un `Dockerfile` donde cada instrucción crea una nueva capa en la imagen.

Los contenedores son la instancia de la imagen. Se crean a partir de la imagen e incluye una capa de escritura sobre las capas de la imagen. 

Los contenedores se pueden arrancar, detener, mover y hasta eliminar, pero la imagen base se mantiene intacta.

#### Registry
Es un espacio centralizado para almacenar y compartir imágenes.
[Docker Hub](https://hub.docker.com/) es un `Registry` público que quien sea puede usar.
![](Pasted%20image%2020260301205419.png)

#### Layers Vs Copy-on-Write
Las imágenes están compuestas por múltiples capas de solo lectura. Cada una representando un puñado de cambios en el`filesystem`.

Cuando el contenedor se crea, se añade una capa de escritura por sobre las demás capas antes mencionadas. 

`Copy-on-Write (CoW)` Es una estrategia que surge cuando se necesita una modificación. Cuando el contenedor modifica un archivo, se copia dicho archivo desde la capa de solo lectura hacia la capa de escritura.

Con este método se minimiza el uso de disco y acelera la creación de contenedores.

#### Namespaces y cgroups
`Namespaces` son prestaciones del `Kernel` de Linux que otorga la capacidad de aislar a los contenedores de ellos mismos y de la máquina que hace de host. 
Entonces `Docker`usa los `Namespaces` para aislar los espacios de trabajo de cada contenedor, limitando el acceso a únicamente lo que está dentro de dicho `Namespace`

En cambio `Cgroups` asegura que cada contenedor obtenga una justa proporción de los recursos y así evitar que un solo contenedor pueda llevarse todos los recursos del sistema.

### 3. Almacenamiento

#### Volúmenes
Por defecto todos los archivos son creados en la capa de escritura de un contenedor. La cual está encima de las capas de solo lectura.

La capa de escritura no perdura luego de que un contenedor es destruido. Lo que significa que puede ser difícil conseguir la data del contenedor destruido.

Una alternativa son los volúmenes. Quienes son unidades de almacenamiento para contenedores, creados y manejados por `Docker`

Los volúmenes son una buena opción para los siguientes casos:
- Facilidad de backup
- Manejo de los volúmenes mediante `Docker CLI`
- Funcionan tanto para Linux como para Windows
- Mayor seguridad al compartir entre contenedores
- Mejor performance de I/O

Empecemos por crear un contenedor:
```bash
docker run -it --rm busybox
```

A manera de ejemplo vamos a crear un volumen nuevo
```bash
# Creando volumen
docker volume create vol-test
# Listando los volúmenes
docker volume ls
# Inspect
docker volume inspect vol-test
```

Ahora deseamos montar el volumen:
```bash
# Método 1
docker run -it --rm --mount type=volume,src=vol-test,dst=/root/test busybox
# Método 2
docker run -it --rm -v vol-test:/root/test busybox
```

Para eliminar el volumen:
```bash
docker volume rm myvol2
```

***Documentación Oficial:*** [volumes](https://docs.docker.com/engine/storage/volumes/)


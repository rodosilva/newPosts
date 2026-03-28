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

![](Pasted%20image%2020260322130103.png)

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
Link: [Install Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
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
docker volume rm vol-test
```

También podemos tener un `volume-subpath`. Eso quiere decir que el volumen tendrá diferentes directorios de forma separada.
```bash
# Primero creamos el subpath en este caso llamado subdirectory1
docker run -it --rm --mount type=volume,src=vol-test,dst=/directory1 busybox mkdir -p /directory1/subdirectory1

# Lo podremos ver así
sudo ls -la /var/lib/docker/volumes/vol-test/_data
drwxr-xr-x 5 root root 4096 Mar 11 19:47 .
drwx-----x 3 root root 4096 Mar 10 20:24 ..
drwxr-xr-x 2 root root 4096 Mar 11 19:47 subdirectory1

# Finalmente podemos montar solo ese subpath recien creado
docker run -it --rm --mount type=volume,src=vol-test,dst=/mount,volume-subpath=subdirectory1 busybox
```

***Documentación Oficial:*** [volumes](https://docs.docker.com/engine/storage/volumes/)

#### Bind Mounts
Cuando usamos `Bind Mounts` un archivo o directorio es montado desde la máquina anfitrión hacia el contenedor.

Cuando usar:
- Compartir código
- Cuando deseas que archivos del contenedor persistan en la máquina anfitrión
- Compartir archivos de configuración

```bash
# Método 1
docker run -it --rm --mount type=bind,src=./quickScripts,dst=/scripts busybox
# Método 2 (En Este caso Docker puede llegar a crear un directorio en la máquina local)
docker run -it --rm -v ./noExiste:/scripts busybox
```

***Documentación Oficial:*** [bind-mounts](https://docs.docker.com/engine/storage/bind-mounts/)
### 4. Redes y Conectividad
Los contenedores vienen con la red habilitada por defecto, por lo que pueden hacer conexiones externas con normalidad.

Cuando arrancamos un contenedor, estará conectado a la `default bridge`. Esto a modo de "masquerading", lo que significa que, si la máquina anfitrión tiene salida a internet, no es necesaria ninguna configuración adicional para que el contenedor también tenga. 

```bash
docker run --rm -ti busybox ping -c1 docker.com
```

Solo para adicionar, Docker crea reglas `iptable` en la máquina anfitrión de manera automática. Esto para garantizar el buen funcionamiento del `bridge network`

```bash
sudo iptables -L
```
#### Mapeo de Puertos
Por defecto, Docker bloquea el acceso a puertos que no hayan sido publicados.

Los puerto publicados del contenedor son mapeados hacia la IP de la máquina anfitrión, para esto Docker maneja las reglas del firewall para realizar NAT "Network Address Translation", PAT "Port Address Translation" y "masquerading"

```bash
docker container run --publish 8080:80 nginx:alpine
```

#### Redes Bridge
Docker automáticamente selecciona la subnet del `default address pools`. Dichos pools pueden ser configurados en `/etc/docker/daemon.json`. 

Por defecto son:

```json
{
  "default-address-pools": [
    {"base":"172.17.0.0/16","size":16},
    {"base":"172.18.0.0/16","size":16},
    {"base":"172.19.0.0/16","size":16},
    {"base":"172.20.0.0/14","size":16},
    {"base":"172.24.0.0/14","size":16},
    {"base":"172.28.0.0/14","size":16},
    {"base":"192.168.0.0/16","size":20}
  ]
}
```

Si bien en la mayoría de casos usaremos la red por defecto, podemos crear nuestra propia:
```bash
# Crear
docker network create -d bridge net-test
# Listar
docker network ls
```

Y así crear un par de contenedores dentro de la red `net-test` recién creada
```bash
# Contenedor 1
docker run --rm -ti --name contenedor1 --network net-test busybox
# Contenedor 2
docker run --rm -ti --name contenedor2 --network net-test busybox
```

### 5. Contenedores
#### Arranque automático
Podemos usar la `Restart Policy` en un contenedor simplemente añadiendo `--restart` al momento de usar el comando `docker run`:

| Flag                       | Descripción                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `No`                       | Por defecto. No se reinicia el contenedor                                                                             |
| `on-failure[:max-retries]` | En caso de un `non-Zero exit code` El contenedor se reinicia<br>También se puede añadir el número límite de intentos. |
| `always`                   | Siempre                                                                                                               |
| `unless-stopped`           | Siempre excepto cuando se detiene manualmente                                                                         |
```bash
docker container run --publish 8080:80 --restart unless-stopped nginx:alpine
```

### 6. Imágenes
#### Pull y Push
Cuando usamos por ejemplo `docker run -it --rm busybox`, y si es que no tenemos la imagen `busybox` ya alojada en nuestra máquina, lo que ocurre es que Docker realiza una descarga de la imagen.
```bash
docker images
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
busybox      latest    af3f0f48a24e   17 months ago   4.43MB
```

Pero, ¿De donde descarga la imagen?
Por defecto, Docker jala las imágenes de [Docker Hub](https://hub.docker.com/) (Siempre y cuando la imagen sea pública)

Por ejemplo la imagen que hemos venido usando: `busybox` se encuentra [aquí](https://hub.docker.com/_/busybox)

Y si quisiéramos simplemente descargar la imagen el comando sería:
```bash
docker pull busybox
```

Por el contrario, nosotros también podemos hacerle `push` a nuestras imágenes.
No obstante, para esto necesitaremos tener una cuenta activa en [Docker Hub](https://hub.docker.com/)

Ya cuando tengamos la cuenta, deberemos hacer `docker login`. Las credenciales de autenticación se almacenan en `$HOME/.docker/config.json`

#### Tags y Versionado
Antes de poder hacer `docker push` o `docker image push`, necesitamos tener un `tag` válido.

Para ello deberemos seguir ciertos componentes:
`[HOST[:PORT]/]NAMESPACE/REPOSITORY[:TAG]`

- `HOST:PORT`: Aquí se especifica la ubicación del `registry`. Por defecto es `docker.io`. Así como el puerto
- `NAMESPACE/REPOSITORY`: El `NAMESPACE` representa al usuario u organización. El `REPOSITORY` es necesario para identificar a la imagen.
- `TAG`: Un identificador opcional para identificar la versión o variante de la imagen.

```bash
# Tag a la imagen af3f0f48a24e
docker tag af3f0f48a24e rodosilva/busybox:1.0
```

Ahora sí podemos empezar a subir imágenes al `Docker Registry`
```bash
docker push rodosilva/busybox:1.0
```

En dicho ejemplo estaríamos subiendo la imagen al registry `docker.io` dentro del `NAMESPACE` o usuario `rodosilva` con un nombre de repositorio `busybox` en su versión `1.0`

![](Pasted%20image%2020260315204043.png)

#### Docker Hub y registries privados
Ahora podemos explorar un poco nuestra cuenta y nuestros repositorios. En mi caso son:
[Repositorios](https://hub.docker.com/repositories/rodosilva)

Al ser una cuenta gratuita, podemos subir imágenes publicas. Es decir de acceso para cualquier usuario. No obstante podemos subir un repositorio privado.
![](Pasted%20image%2020260315205627.png)
[Default Privacy](https://hub.docker.com/repository-settings/default-privacy)

Como ya se ha mencionado antes, si bien el `registry` por defecto es `docker.io`, es posible usar `private registries`.

Para ello durante el `tag` deberemos añadir más detalles:
```bash
docker tag 0e5574283393 myregistryhost:5000/fedora/httpd:version1.0
```

Donde `myregistryhost` es el nombre del registry privado y `5000` es el puerto que se está usando para recibir las imágenes.

### 7. Dockerfile

#### Instrucciones
Docker builds images by reading the instructions from a Dockerfile. A Dockerfile is a text file containing instructions for building your source code. The Dockerfile instruction syntax is defined by the specification reference in the [Dockerfile reference](https://docs.docker.com/reference/dockerfile/).

Here are the most common types of instructions:

Docker crea las imágenes a partir de la lectura de instrucciones de un `Dockerfile`. Que es básicamente un documento de texto. La sintaxis está definida por esta [referencia](https://docs.docker.com/reference/dockerfile/)

Entre los más comunes encontramos:

| Instrucción                                                                                       | Descripción                     |
| ------------------------------------------------------------------------------------------------- | ------------------------------- |
| `FROM <image>`                                                                                    | Define la base de la imag       |
| `RUN <command>`                                                                                   | Ejecuta comandos en una nueva c |
| `WORKDIR <directory>`                                                                             | Define el directorio de trabajo |
| `COPY <src> <dest>`                                                                               | Copia archivos o direct         |
| `CMD <command>`   Define el programa por defecto que correrá una vez iniciado el contenedor ciado |                                 |
Ejemplo:
```dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:22.04
ARG FLASK_APP

# install app dependencies
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip install flask==3.0.*

# install app
COPY helloWorld.py /
COPY templates/ /templates/

# final configuration
ENV FLASK_APP=${FLASK_APP}
EXPOSE 8000
CMD ["flask", "run", "--host", "0.0.0.0", "--port", "8000"]
```

Una vez que tengamos el `Dockerfile`, ya podemos construir la imagen así:
```bash
docker build -t test:latest --build-arg FLASK_APP=helloWorld .
```

Sabiendo que al usar `.` buscara un archivo llamado `dockerfile` en el directorio donde ejecutamos el `docker build`

Esto crea la imagen, no obstante debemos correr el contenedor así:
```bash
docker run --name flaskApp -p 127.0.0.1:8000:8000 test:latest
```

También podemos entrar al contenedor:
```bash
docker exec -it flask /bin/bash
```
#### Argumentos (ARG) Vs Variables de Entorno (ENV)
Dentro de las instrucciones de un `Dockerfile` vamos a encontrar a un par que a primera vista podrían sonar muy parecidas: Los argumentos y las variables de entorno

En cuanto a los **argumentos** `ARG` son variables utilizadas únicamente durante la creación del contenedor. Inclusive la `flag` en línea de comando es `--build-arg` 

En cambio las **variables de entorno** `ENV` están disponibles durante la construcción del contenedor pero también persisten en la imagen final y dentro del contenedor que quede corriendo.

#### Secrets
Argumentos y variables de entorno son inapropiadas para el manejo de información sensible, ya que persisten en la imagen y hasta se pueden ver durante la creación on en los logs.

Para esto tenemos a los `secret mounts`. Tomemos este `dockerfile` como ejemplo:

```dockerfile
FROM debian:stable-slim
RUN --mount=type=secret,id=SECRET_TEST,target=/run/secrets/SECRET_TEST \
    cat /run/secrets/SECRET_TEST > /tmp/just_to_test_secret

CMD ["cat", "/tmp/just_to_test_secret"]
```
Estamos montando un secret `--mount=type=secret` con un `id=SECRET_TEST` en un `target` que solo estará presente durante ese `RUN` en específico.

Para nuestro ejemplo, y únicamente como medida didáctica, estamos aprovechando en copiar ese `SECRET_TEST` a un archivo temporal `/tmp/just_to_test_secret`

Es importante mencionar que al usar `id=SECRET_TEST` estamos declarando dos cosas. el `id` y una variable de entorno `ENV` también llamada `SECRET_TEST`

Entonces podemos usar una variable de entorno
```bash
export SECRET_TEST="this-is-the-secret-123"
docker build --secret id=SECRET_TEST -t mysecret .
```

Pero también un archivo `secrets.txt`. Para esto necesitamos darle un `src`
```bash
docker build --secret id=SECRET_TEST,src=./secrets.txt -t mysecret .
```

Al correr el contenedor veremos la ejecución del `CMD` 
```bash
docker run --rm mysecret
```

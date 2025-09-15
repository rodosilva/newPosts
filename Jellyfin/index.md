+++
date = '2025-09-14T20:13:15-05:00'
title = 'Jellyfin Servidor Multimedia Como Contenedor Docker'
+++

## ¿Qué es Jellyfin?
Es un servidor multimedia que puedes utilizarlo para reproducir películas y series de forma local.

## Jellyfin Como Contenedor Docker
Si es que eres un usuario de `Linux`, **Jellyfin** te da la opción de desplegar el servidor multimedia a modo de contenedor.

Esto te da una oportunidad para experimentar con soluciones `Docker` y poder practicar el manejo de contenedores. Es una excelente forma para crear tus propios laboratorios y a su vez obtener herramientas de entretenimiento como lo es este servidor multimedia.

### Crear y Correr el Contenedor
En mi caso esto viene de un proyecto personal más grande al que llamo `myHomeLab`. El cual se basa en el despliegue de diferentes herramientas o aplicaciones en mi `raspBerryPi`.

```yaml
- name: My HomeLab Playbook
  hosts: raspberryPi
  become: true
  become_user: root

  roles:
   - samba
   - jellyfin
```

En otra publicación se podrá ver más a detalle como vengo desarrollando el proyecto `myHomeLab`, pero lo importante aquí es ver que durante el despliegue de los roles del `Ansible playbook`, uno de ellos es **Jellyfin**

Si nos adentramos al ese rol en específico veremos un par de scripts.
Uno que básicamente crea el contenedor y el otro que lo arranca.

```yaml
---
# tasks file for jellyfin

- name: Run script to build the Jellyfin Container
  ansible.builtin.script: roles/jellyfin/files/build-jellyfin.sh

- name: Run script to run Jellyfin Container
  ansible.builtin.script: roles/jellyfin/files/run-jellyfin.sh
```

Para la creación y el arranque del contenedor utilizo como base la [documentación](https://jellyfin.org/docs/general/installation/container?method=docker-cli) de la página oficial de `Jellyfin`.

Para que todo forme parte del flujo de despliegue de mi proyecto de `myHomeLab` añadí algunas líneas de código tanto para la creación como para el arranque y quedó algo así:

```bash
# Este script se encarga de descargar la imagen de jellyfin/jellyfin y de crear los
# persistent volumes

# Verificamos si la imagen ya existe
if [[ -z $(docker images | grep -o jellyfin/jellyfin) ]]; then
  echo "No existe la imagen jellyfin/jellyfin, descargando..."
  docker pull jellyfin/jellyfin
else
    echo "La imagen jellyfin/jellyfin ya existe..."
fi

# Verificamos si los volúmenes ya existen
if [[ -z $(docker volume ls | grep -o jellyfin-config) ]]; then
  echo "No existe el volumen jellyfin-config, creando..."
  docker volume create jellyfin-config
else
    echo "El volumen jellyfin-config ya existe..."
fi

if [[ -z $(docker volume ls | grep -o jellyfin-cache) ]]; then
  echo "No existe el volumen jellyfin-cache, creando..."
  docker volume create jellyfin-cache
else
    echo "El volumen jellyfin-cache ya existe..."
fi
```

```bash
# Este script se encarga de correr el contenedor de jellyfin/jellyfin
# Junto a sus configuraciones necesarias.

docker run -d \
 --name jellyfin \
 --user $(id -u rodo):$(id -g rodo) \
 --net=host \
 --volume jellyfin-config:/config \
 --volume jellyfin-cache:/cache \
 --mount type=bind,source=/mnt/external/PELICULAS,target=/media \
 --restart=unless-stopped \
 -p 8096:8096 \
 jellyfin/jellyfin
```

Naturalmente hay mucho espacio para la mejora y seguramente el código vaya a cambiar en un futuro próximo. Sin embargo, hay que considerar que esto es un laboratorio.

## Resultado
El resultado es la obtención de una plataforma multimedia desde la IP de mi `raspberryPi` utilizando el puerto `8096`.

Luego de pasar por varios pasos de configuración inicial, podremos ver la interface de selección de mis películas y series que estén en la ruta `/mnt/external/PELICULAS`

![](Pasted%20image%2020250914195938.png)

De momento solo tengo una película, pero siendo este un disco duro externo montado en mi `raspberryPi`, la forma de añadir más multimedia es solo cuestión de copiar pegar.

Y dado que funciona a modo de aplicación, es posible descargar la `App`de `Jellyfin` para Android en tu televisor y simplemente añadir la dirección IP local a modo de servidor.

Con eso podrás tener una fuente centralizada (servidor multimedia) y vincular varios televisores, tablets, celulares o la misma PC para consumir el contenido que tengas disponible.

![](Pasted%20image%2020250914201209.png)

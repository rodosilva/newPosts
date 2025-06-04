+++
date = '2025-06-03T19:03:38-05:00'
title = 'Manejo De Discos'
+++

## Introducción
La idea de este artículo es brindar la información necesaria para el manejo de discos en Linux.

## Montar Unidades de Windows en Linux
`NTFS` es el sistema de archivos estándar de Windows para la gestión de datos en discos y unidades de almacenamiento.
En caso hayamos conectado una unidad de almacenamiento o disco duro externo en nuestra estación de trabajo con `Ubuntu` por ejemplo, necesitaremos seguir estos pasos en caso no podamos ver el contenido de dicha unidad.
```bash
# Listar discos y particiones
lsblk
# Arreglar problemas ntfs 
sudo ntfsfix /dev/sda1
```
**_NOTA:_**`sda1` es un ejemplo. Ahí debe ir la partición que queremos usar 

Luego de ello, podremos montar de la siguiente forma:
```bash
sudo mount -t ntfs /dev/sda1 /media/rodrigo/unidad/ 
```
Donde `/dev/sda1` es la partición que hemos reparado y `/media/rodrigo/unidad/` es un directorio previamente creado en nuestro ordenador donde lo montaremos.

## LVM en Linux: Crear y Extender un Volumen Lógico
`LVM` permite combinar volúmenes físicos como si fueran parte de un `pool`, en lugar de usarlos de forma individual.
Para entender la forma de usar `LVM` debemos conocer 3 conceptos:
- Volúmenes físicos
- Grupo de volúmenes
- Volúmenes lógicos
![](Pasted%20image%2020250603201333.png)

### Crear un volumen físico
Si ya tenemos un disco a disposición (ejemplo: `sda`), deberemos darle formato:
```bash
# Listar discos
sudo fdisk -l
## Darle formato
sudo fdisk /dev/sda
> p #Print
> [default]
> [default]
> [default]
> t # Type
> 8e #Linux LVM
> p #Print
> w #Write
```
Se creará `/dev/sda1`

Luego procederemos a crear el disco:
```bash
sudo pvcreate /dev/sda1
sudo pvdisplay
```

Ahora lo haremos formar parte de un grupo
```bash
# Crear un grupo llamado vg-data
sudo vgcreate vg-data /dev/sda1
# Ver los grupos
sudo vgs
```

Es momento de crear el disco lógico
```bash
# Crear un disco lógico llamado lv-data
lvcreate --name lv-data -l 100%FREE vg-data
# Listar
sudo lvdisplay /dev/vg-data/lv-data
```

Finalmente debemos darle formato a este nuevo `LV` 
```bash
# Make a filesystem
sudo mkfs.xfs /dev/vg-data/lv-data
```

Para poder hacer uso del disco debemos montarlo en algún directorio:
```bash
sudo mkdir -p /data
sudo mount /dev/vg-data/lv-data /data
```
Si deseamos que sea permanente, deberemos añadir una línea en `/etc/fstab`

Ya deberíamos poder verlo entre los filesystems
```bash
df -khT
```

### Extender un volumen lógico
Para esto deberemos tener un nuevo disco físico y darle formato tal y como hicimos previamente con `fdisk /dev/sdb`, para luego crear el disco físico con `pvcreate /dev/sdb1`

Hecho eso ya podemos extender un grupo existente:
```bash
# Extender
vgextend vg-data /dev/sdb1
# Listar
vgs
```

Ahora podemos extender el volumen lógico:
```bash
# Listar
lvs
# Extender
lvextend -l +100%FREE /dev/vg-data/lv-data
```
Eso si deseamos extender el 100%, pero también podemos extender cierta cantidad deseada con `lvextend -L +5G /dev/vg-data/lv-data`

Finalmente debemos extender el filesystem
```bash
xfs_growfs /dev/vg-data/lv-data
```




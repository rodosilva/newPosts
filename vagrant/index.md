+++
date = '2024-12-15T22:11:59-05:00'
title = 'Vagrant'
+++

En este laboratorio crearemos un entorno con dos servidores Ubuntu utilizando
la herramienta de Vagrant.

¿Por qué Vagrant?
Dada la velocidad cambiante de tecnología, necesitamos tener espacios de infraestructura que nos ayude a probar, construir y practicar en un entorno seguro, ágil y fácilmente manejable.

Con Vagrant, tenemos la seguridad de que cualquier cosa que se malogre, será fácilmente reemplazable y así poder empezar desde cero en uno o varios servidores en blanco. 

## Cheat Sheet
- `vagrant init`: Crea una plantilla de un `Vagrantfile`
- `vagrant up`: Levanta la infraestructura basada en el `Vagrantfile`
- `vagrant ssh`: `ssh` hacia alguna `box`
- `vagrant reload`: Refresca las configuraciones del `Vagrantfile` hacia las `boxes`
- `vagrant status`: Ver las `boxes` y su estado
- `vagrant destroy`: Destruye las `boxes`
- `vagrant snapshot save [Nombre Host] [Nombre Snapshot]`: Creando un snapshot
- `vagrant snapshot list`: Lista los snapshots
- `vagrant snapshot restore [Nombre Host] [Nombre Del Snapshot]`: Restaura al snapshot indicado
- `vagrant snapshot push`: Añade al snapshot a la pila
- `vagrant snapshot pop`: Toma el último elemento de la pila

## Capítulo 1: Requerimientos

- VirtualBox: [Instalación](https://www.virtualbox.org/wiki/Linux_Downloads)
- Vagrant: [Instalación](ttps://developer.hashicorp.com/vagrant/install)

## Capítulo 2: Mi Primer Vagrantfile

Vamos a iniciar creando una máquina virtual utilizando solamente código.
Para ello, crearemos un nuevo documento dentro de cualquier carpeta destinada para nuestro proyecto

El documento deberá llamarse `vagrantfile`

Lo primero que debemos elegir es la versión de la configuración que estaremos utilizando.
La última versión que se tiene `2`

Dado que nuestro proyecto se basa en 2 servidores Ubuntu, procederemos con elegir nuestro `Vagrant Box` desde el  [catálogo](https://portal.cloud.hashicorp.com/vagrant/discover/ubuntu?prev=ChRXeUozYVd4NU16SXRhblZxZFNKZA%3D%3D)

Finalmente, crearemos un nuevo bloque para nuestro primer `host` que llamaremos `labServer01` y le asignaremos una `IP estática` de `192.168.56.10` 

```bash
Vagrant.configure("2") do |config|
  
    ## Definir el OS de forma global
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_version = "20191107.0.0"
    
    ## Definir Un Nuevo Bloque
  
    config.vm.define "labServer01" do |host|
      ## Definir Maquina virtual dentro de este Bloque
      host.vm.network "private_network", ip:"192.168.56.10"
    end
end
```

## Capítulo 3: Redes y Reenvío de Puerto
En cuanto a la asignación de `IP` para nuestras `boxes`, tenemos dos opciones.

**La primera** sería darle una `ip` de la misma red de nuestra máquina `host` y formar un `bridge`.
Para ello utilizaremos la línea:
`host.vm.network "public_network"`

La forma completa se vería así:
```bash
Vagrant.configure("2") do |config|
  
    ## Definir el OS de forma global
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_version = "20191107.0.0"
    
    ## Definir Un Nuevo Bloque
  
    config.vm.define "labServer01" do |host|
      ## Definir Maquina virtual dentro de este Bloque
      host.vm.network "public_network"
    end
end
```

**La segunda** opción sería darle una `ip` fija utilizando `host.vm.network "private_network", ip:"xxx.xxx.xxx.xxx"`

```bash
Vagrant.configure("2") do |config|
  
    ## Definir el OS de forma global
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_version = "20191107.0.0"
    
    ## Definir Un Nuevo Bloque
  
    config.vm.define "labServer01" do |host|
      ## Definir Maquina virtual dentro de este Bloque
      host.vm.network "private_network", ip:"192.168.56.10"
    end
end
```

**Adicional a ello**, podemos reenviar puertos de la `box` hacia el `host` o anfitrión.

Para ello utilizaremos `host.vm.network "forwarded_port", guest:80, host:8080`

```bash
Vagrant.configure("2") do |config|
  
    ## Definir el OS de forma global
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_version = "20191107.0.0"
    
    ## Definir Un Nuevo Bloque
  
    config.vm.define "labServer01" do |host|
      ## Definir Maquina virtual dentro de este Bloque
      host.vm.network "private_network", ip:"192.168.56.10"
      host.vm.network "forwarded_port", guest:80, host:8080
    end
end
```
En ese ejemplo, nuestro puerto local `8080` sera dirigido hacia el puerto `80` del la máquina virtual.

## Capítulo 4: Múltiples Máquinas Virtuales
Para generar más de una máquina virtual, deberemos asignar bloques.
Para ello utilizaremos la línea `config.vm.define "host_1" do |host|` formando así un `vagrantfile` muy parecido a este:

```bash
Vagrant.configure("2") do |config|
  
  ## Definir el OS de forma global
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_version = "20191107.0.0"
  
  ## Definir Nuevo Bloque
  ###### HOST 1 ##### 
  config.vm.define "labServer01" do |host|
    ## Definir Maquina virtual dentro de este Bloque
    #host.vm.box = "ubuntu/trusty64"
    host.vm.network "private_network", ip:"192.168.56.10"
  end

  ##### HOST 2 #####
  config.vm.define "labServer02" do |host|
    host.vm.network "private_network", ip:"192.168.56.20"
  end
end
```

## Capítulo 5: Uso de Scripts
Durante la construcción que se de de las `boxes` podemos aprovisionar o ejecutar una serie de comandos definidos en un `script`

**La primera** forma sería con las líneas de código dentro del mismo `vagrantfile` 

```bash
$script = <<-SCRIPT

  sudo apt-get update
  sudo apt-get install nginx -y

SCRIPT

Vagrant.configure("2") do |config|
  
  ## Definir el OS de forma global
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_version = "20191107.0.0"
  
  ## Definir Nuevo Bloque
  ###### HOST 1 ##### 
  config.vm.define "labServer01" do |host|
    ## Definir Maquina virtual dentro de este Bloque
    #host.vm.box = "ubuntu/trusty64"
    host.vm.network "private_network", ip:"192.168.56.10"
    host.vm.provision "shell", inline: $script
  end

  ##### HOST 2 #####
  config.vm.define "labServer02" do |host|
    host.vm.network "private_network", ip:"192.168.56.20"
    host.vm.provision "shell", inline: $script
  end
end
```

**La segunda** forma sería utilizando un archivo externo `*.sh`
```bash
Vagrant.configure("2") do |config|
  
  ## Definir el OS de forma global
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_version = "20191107.0.0"
  
  ## Definir Nuevo Bloque
  ###### HOST 1 ##### 
  config.vm.define "labServer01" do |host|
    ## Definir Maquina virtual dentro de este Bloque
    #host.vm.box = "ubuntu/trusty64"
    host.vm.network "private_network", ip:"192.168.56.10"
    host.vm.provision "shell", path: "./script.sh"
  end

  ##### HOST 2 #####
  config.vm.define "labServer02" do |host|
    host.vm.network "private_network", ip:"192.168.56.20"
    host.vm.provision "shell", path: "./script.sh"
  end
end
```

Para ese ejemplo, el archivo ejecutable `./script2.sh"`
end estaría dentro del mismo directorio que el `vagrantfile`

## Capítulo 6: Compartir Archivos
Es posible compartir un archivo de nuestra máquina local hacia nuestra `box` y viceversa.

La línea de código es de la siguiente forma:
`config.vm.synced_folder "./code", "/home/vagrant", disabled: false`

Dentro del `vagrantfile` se vería así:
```bash
Vagrant.configure("2") do |config|
  
    ## Definir el OS de forma global
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_version = "20191107.0.0"
    
    ##### HOST 1 ##### 
    config.vm.define "labServer01" do |host|
      ## Definir Maquina virtual dentro de este Bloque
      host.vm.hostname = 'labServer01'
      host.vm.network "private_network", ip:"192.168.56.10"

      host.vm.synced_folder "./git", "/home/vagrant/git", disabled: false
      host.vm.synced_folder "./bash", "/home/vagrant/bash", disabled: false

      host.vm.provision "shell", path: "./script.sh"

    end
end
```
Para dicho ejemplo, tanto los directorios locales `./git/` y `./bash/` se estarían sincronizado con los directorios del `box` `/home/vagrant/git` y `/home/vagrant/bash` respectivamente.


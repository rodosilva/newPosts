+++
date = '2025-02-20T23:18:07-05:00'
title = 'Ubuntu 24 desde Windows 11 Usando WSL 2'
+++

## Objetivo
En este post revisaremos los pasos a seguir para la correcta configuración de `WSL` en `Windows 11` para así tener `Ubuntu`

## Pasos a Seguir
### 1. Activar Características en Windows
Primero deberemos activar desde las `características de Windows` lo siguiente:

- Hiper-V

![](Screenshot%20from%202025-02-20%2022-11-42.png)

- Subsitema de Windows para Linux

![](Screenshot%20from%202025-02-20%2022-13-08.png)

### 2. Instalar WSL
Ahora nos toca instalar `WSL` en nuestro windows desde `PowerShell`
 
```  
wsl --install  
```  

Para validar que haya instalado podemos usar el siguiente comando:  

```  
wsl -l -v  
```  

Es recomendable utilizar `WSL 2` por lo que colocaremos como versión por defecto:

```  
wsl --set-default-version <Version#>  
```  

También se puede usar este comando:

```  
wsl --set-version  
```  

  
### 3. Instalar Ubuntu desde la Microsoft Store
Es momento de descargar `Ubuntu`. En este caso estaremos utilizando `Ubuntu 24`
Simplemente necesitamos ir a la `Microsoft Store` y colocar `WSL` en el buscador.
Entre los resultados podremos encontrar `Ubuntu 24.01.1 LTS`

![](Screenshot%20from%202025-02-20%2022-20-11.png)

Una vez instalado podemos hacer `Ubuntu` nuestra `distro` por defecto

```  
wsl --set-default <DistributionName>  
```  

### 4. Configuraciones Adicionales  

Para `Windows 11` existen algunas configuraciones adicionales. Una de ellas la podemos configurar de la siguiente forma:

```  
wsl.exe --install --no-distribution  
```  

Para refrescar las configuraciones podemos:  

```  
wsl --shutdown  
```  

Antes de volver a iniciar el `WSL` hay que configurar el modo de red a `mirrored`.
Esto se hace para que nuestro `Ubuntu` que vivirá dentro de este espacio virtual, pueda tener las conexiones de red tal y como las tiene nuestra máquina anfitriona.

Para ello en nuestra ruta local `C:\Users\<UserName>\` 
Colocaremos un archivo llamado `.wslconfig`
Con el contenido:
```
[wsl2]
networkingMode = mirrored
```

## Referencias
- Características de Windows: Ver [aquí](https://platzi.com/tutoriales/1650-prework-2019/5895-aprende-a-instalar-wsl-2-de-la-manera-sencilla/)
- Instalación de Linux en Windows: Ver [aquí](https://learn.microsoft.com/es-es/windows/wsl/install)
- Configuraciones avanzadas WSL: Ver [aquí](https://learn.microsoft.com/en-us/windows/wsl/wsl-config)

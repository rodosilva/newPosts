+++
date = '2025-07-20T21:43:33-05:00'
title = 'Blog Con Hugo Y Github Pages'
+++
La idea de este post es mostrar el paso a paso para obtener un Blog personal.
Está no es más que una de las tantas alternativas que existen allá afuera, sin embargo, con este método, obtendrás un Blog en la Web, sin costo y que te permite añadirle posts y páginas de forma sencilla, rápida y de manera automática.

## Pre-Requisitos
- [Hugo](https://gohugo.io/installation/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
## Hugo: Primeros Pasos
Hugo es un framework que utilizaremos para tener una plantilla para nuestro blog.
Entonces, el primer paso sería instalar `HUGO`

Lo ideal sería seguir los pasos de la [página oficial](https://gohugo.io/getting-started/quick-start/)
Pero aquí te dejo un resumen en caso estés usando `Linux`
```bash
# Instalar Hugo usando snap
sudo snap install hugo
# Instalar Hugo usando apt
sudo apt install hugo
```
> ***Nota:** Para la primera alternativa deberás tener snap ya instalado*

Para verificar la instalación:
```bash
$ hugo version
hugo v0.148.1-98ba786f2f5dca0866f47ab79f394370bcb77d2f+extended linux/amd64 BuildDate=2025-07-11T12:56:21Z VendorInfo=snap:0.148.1
```

Ahora es momento de elegir el [tema](https://themes.gohugo.io/) que vas a utilizar.
En mi caso voy a elegir el [hugo-blog-awesome](https://themes.gohugo.io/themes/hugo-blog-awesome/)
A partir de aquí, toca ir personalizando nuestro tema:
Pero básicamente es:
Crear un nuevo site llamado `blogTest` de forma local
```bash
hugo new site blogTest
```

Iniciamos nuestro `git`
```bash
git init
```

Clonamos el repositorio de `hugo-blog-awesome` dentro del directorio `themes` de tu nuevo site: 
```bash
cd blogTest
git clone https://github.com/hugo-sid/hugo-blog-awesome.git themes/hugo-blog-awesome
```

El archivo es el archivo principal de configuración. Como primera linea de instrucción debes decirle que utilice el nuevo tema:
```bash
echo "theme = 'hugo-blog-awesome'" >> hugo.toml
```

Ya puedes tener una visualización inicial. 
Naturalmente aun no tendrá contenido pero ya podrás ir viendo la base de tu web de forma local:
```bash
hugo server
```

## HUGO: Crear contenido
Es momento de crear el primer `post`.
Para ello simplemente deberás ejecutar el comando:
```bash
hugo new content content/posts/my-first-post.md
```

Con esto se crea un archivo llamado `my-first-post.md` en la ruta `content/posts/`.
Puedes observar que dicho archivo tendrá una cabecera muy parecida a esta:
```bash
+++
date = '2025-07-17T22:43:50-05:00'
draft = true
title = 'My First Post'
+++
```

Notarás también una línea que dice `draft = true`, lo que significa que tu post está en borrador y no será publicado.
Si lo que quieres el verlo en borrador, simplemente ejecutarás
```bash
hugo server -D
```

Si consideras que ya está listo para publicar, simplemente deberás borrar la línea y usar el comando antes visto:
```bash
hugo server
```

## HUGO: Personalizando Tema
Es importante revisar el `README.md` del tema de HUGO que hayas elegido.
En este caso podemos notar que el tema [hugo-blog-awesome](https://github.com/hugo-sid/hugo-blog-awesome/blob/main/README.md) menciona que entre sus archivos tiene un ejemplo.
Ahí podrás encontrar un [hugo.toml](https://github.com/hugo-sid/hugo-blog-awesome/blob/main/exampleSite/hugo.toml). El cual es el principal archivo de configuración que deberás modificar para generar los cambios y personalizaciones que veas conveniente.
En este caso utilízalo como guía para hacer los cambios que veas conveniente.
Para comenzar, creo que los cambios más importantes son los siguientes:

### Directorio del Contenido
El primer paso es definir el directorio del contenido `contentDir`. 
Se suele crear sub directorios cuando se trabaja con diferentes idiomas pero dado que este es un blog de iniciación, lo dejaremos con un solo directorio:
```bash
contentDir = "content"
```

### Barra de Menú
Ahora toca definir lo que quieres que muestra la barra de menú.
Por lo general se coloca un `Home`, `Posts` y `About`.
Esto se traduce en añadir las siguientes líneas en tu `hugo.toml`:

```bash
[Languages.en-gb]
  languageName = "English"
  languageCode = "en-gb"
  contentDir = "content"
  weight = 1

  [Languages.en-gb.menu]
  [[Languages.en-gb.menu.main]]
    # The page reference (pageRef) is useful for menu highlighting
    # When pageRef is set, setting `url` is optional; it will be used as a fallback if the page is not found.
    pageRef="/"
    name = 'Home'
    url = '/'
    weight = 10
  [[Languages.en-gb.menu.main]]
    pageRef="posts"
    name = 'Posts'
    url = '/posts/'
    weight = 20
  [[Languages.en-gb.menu.main]]
    pageRef="about"
    name = 'About'
    url = '/about/'
    weight = 30
```
> ***NOTA:*** Hemos dejado los encabezados que vienen en el ejemplo, no hace falta preocuparse por que diga `languageCode = "en-gb"`. Tu contenido puede tranquilamente estar en español si ningún problema.

Con esto estamos añadiendo una barra de menú my parecida a esta:
![](Pasted%20image%2020250720205550.png)

### Imagen Miniatura y Título de la Página
Es momento de colocar una pequeña imagen y un título a gusto personal en el centro.
Para ello simplemente deberás colocar una imagen dentro del directorio `assets/` y mantener el nombre, formato y tamaño de la imagen (628x640)
```bash
ls assets/
avatar.jpg
```

Finalmente añadir las siguientes lineas al ya conocido `hugo.toml`
```bash
  [Languages.en-gb.params.author]
  avatar = "avatar.jpg" # put the file in assets folder; also ensure that     image has same height and width
  # Note: image is not rendered if the resource(avatar image) is not found.   No error is displayed.
  intro = "BLOG DE PRUEBA"
  name = "BlogTest"
  description = "Un blog sencillo y minimalista realizado durante una         prueba"
```

### Añadiendo Redes Sociales y Go to Top
Ya para terminar de personalizar el blog, puedes colocar algunas redes sociales a modo de enlaces.
Además, algo útil es colocar una flecha para ir al inicio de un post cuando ya has terminado de leer y te encuentras bastante abajo de la página.
Añade las lineas al `hugo.toml`
```bash
[[params.socialIcons]]
name = "github"
url = "https://github.com/rodosilva"

[[params.socialIcons]]
name = "linkedin"
url = "https://linkedin.com/in/rodrigo-silva-alegria"

[Languages.en-gb.params]
goToTop = true
```

## HUGO: Archivo de Configuración Final
Con todo lo antes visto, terminarás teniendo un archivo de `hugo.toml` parecido a este:
```bash
baseURL = 'https://example.org/'
languageCode = 'en-us'
title = 'My New Hugo Site'
theme = 'hugo-blog-awesome'

[Languages.en-gb]
languageName = "English"
languageCode = "en-gb"
contentDir = "content"
weight = 1

[Languages.en-gb.menu]
[[Languages.en-gb.menu.main]]
# The page reference (pageRef) is useful for menu highlighting
# When pageRef is set, setting `url` is optional; it will be used as a fallback if the page is not found.
pageRef="/"
name = 'Home'
url = '/'
weight = 10
[[Languages.en-gb.menu.main]]
pageRef="posts"
name = 'Posts'
url = '/posts/'
weight = 20
[[Languages.en-gb.menu.main]]
pageRef="about"
name = 'About'
url = '/about/'
weight = 30

[Languages.en-gb.params]
goToTop = true

[Languages.en-gb.params.author]
avatar = "avatar.jpg" # put the file in assets folder; also ensure that image has same height and width
# Note: image is not rendered if the resource(avatar image) is not found. No error is displayed.
intro = "BLOG DE PRUEBA"
name = "BlogTest"
description = "Un blog sencillo y minimalista realizado durante una prueba"

[[params.socialIcons]]
name = "github"
url = "https://github.com/rodosilva"

[[params.socialIcons]]
name = "linkedin"
url = "https://linkedin.com/in/rodrigo-silva-alegria"
```

Y una apariencia similar a esta:
![](Pasted%20image%2020250720214015.png)

## Github Pages Y Github Actions
SI has llegado hasta acá, notarás que ya tienes un blog; sin embargo, este habita de forma local en tu ordenador.
Cada vez que corres `hugo server` este te muestra un enlace a tu `localhost`: `http://localhost:1313/`
No obstante, lo que queremos es poderlo leer y que otras personas lo puedan leer desde cualquier parte del mundo.
Para ello, usaremos los beneficios de `Github Pages`, pero no solo eso, sino también haremos uso de `Github Actions` para el despliegue de nuestro blog.




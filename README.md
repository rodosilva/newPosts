# newPosts

## Objetivo
Este repositorio contiene las publicaciones en borrador antes de ser publicadas por mi aplicación de [My Blog](https://github.com/rodosilva/myblog).

## Herramienta de anotaciones
Todos los `posts` se redactan utilizando la aplicación de [Obsidian](https://obsidian.md/).

Es importante crear un directorio con el título de la publicación. Dentro se encontrarán las images que forman el `post`

## Publicación
Una vez terminado de redactar y elaborar el `post`, se debe ejecutar el `script` [deploy Posts](./deployPosts.sh). El cual ejecutará los pasos necesarios para copiar o sincronizar la información de cada uno de los `posts` con [My Blog](https://github.com/rodosilva/myblog).

Esto significa que si el `post` no existe, se creará. Si el `post` se a actualizado, incrementará la información en [Mi Blog](https://rodosilva.github.io/myblog/).

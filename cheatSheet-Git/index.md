+++
date = '2024-12-24T11:53:30-05:00'
title = 'CheatSheet Git'
+++

## Comandos

### Instalar
- `sudo apt install git-all`

### LLaves
- `eval "$(ssh-agent -s)"` → Inicializar nuestras llaves
- `ssh -T git@github.com` → Verificar que Git ya tiene nuestra llave 
- `ssh-add ~/.ssh/id_ed25519` → Añadir
- `ssh-keygen -t ed25519 -C "rodosilva.alpha@gmail.com"` → Crear llaves nuevas. Passphrase es una capa extra

### Comandos Git
- `git --version` 
- `git add -A` → Agrega todos los archivos con cambios en el proyecto
- `git add -u` → Todos los archivos modificados o eliminados
- `git add [file | .]` → Pasa área de trabajo al área de Staging
- `git branch` → Ver las ramas
- `git branch -D [develop]` → Borrar rama
- `git branch -M main` → Cambiar el nombre de la rama (forzar)
- `git checkout .` → Descartar cambios del área de trabajo
- `git checkout [--ours | --theirs] [file en conflicto]` → Ours cuando queremos que se conserve que hay en la rama padre, y theirs, la rama hija
- `git checkout [file name]` → Quita los cambios del área de trabajo ejecutadas en ese archivo y lo retorna al último Stage de ese mismo archivo
- `git checkout -b <branch-name> <forked/forked-name>` -> Crea la rama con el nombre desde la ruta forked. 
- `git cherry-pick [hash commit]` → Toma commits y los coloca en mi rama añadiéndolo como un nuevo commit.
- `git clone [URL]` → Clonar un remoto hacia tu local
- `git commit --amend` → Permite editar el mensaje del último commit. También añade los cambios que están en tu área de staging (Lo que añadiste con el git add [file])
- `git commit -m "Mensaje"` → De área de Staging al área del historial de repositorio
- `git config --global user.email "rodosilva.alpha@gmail.com"` → in el global si quieres usar credenciales en repositorio específico
- `git config --global user.email "rodosilva.alpha@gmail.com"` 
- `git config --global user.name "Rodrigo Silva"` 
- `git config --list` → Ver configuración
- `git config color.status.added [blue]` → Darle color a los añadidos
- `git config color.status.branch [magenta]` → Darle color a la palabra de la rama
- `git config color.status.untracked "141 bold"` → Color al untracked en negritas
- `git config user.name` → Ver configuración solo de User
- `git config user.name "Rodrigo Silva"` → Sin el global si quieres usar credenciales en repositorio específico
- `git diff` → Diferencias entre nuestra área de trabajo y área de repositorio. Desde el punto de vista del área de trabajo
- `git fetch forked`-> Carga los remotos a tus ramas. Se suele usar luego de un `git remote add forked`
- `git init` → Carpeta en la que estamos será un repositorio
- `git log` → Ver el historial junto con la información
- `git log --format=[short|medium|full]` → Cantidad de info en los logs
- `git log --oneline` → Log en versión resumida
- `git log -n [2]` → Ver los últimos [2] commits
- `git merge --squash [nueva rama]` → Squash merge
- `git merge [rama Nuevo-Feature]` → Desde la rama main (la que queremos que reciba los cambios)
- `git pull` → Jalar del remoto al local
- `git push -u origin main` → Push al repo remoto -u asocial rama main local con rama main remota. Entonces, la próxima vez no es necesario especificar [origin main]
- `git rebase --interactive` → Permite interactuar con el proceso de rebase. Limpieza de tu historia
- `git rebase main` → Desde una rama secundaria, actualiza y añade los commits de la rama main a nuestra rama secundaria 
- `git remote add origin [URL]` → Añadir la url del Github y tu repo
- `git remote add forked <URL of Forked Repo>`-> Añadir la url de un fork a tus remotos
- `git reset` → Devuelve cambios en archivos a la zona de trabajo
- `git reset --hard [HEAD~1 commit ID]` → Elimina y son no recuperables
- `git reset --mixed [HEAD~1 commit ID]` → Es la de default. Deshace el commit, mantiene los cambios en el área de trabajo
- `git reset --soft [HEAD~1 commit ID]` → Deshace el commit, mantiene los cambios en el stage
- `git restore --staged` → Quitar de stage
- `git revert [hash del commit]` → Nuevo commit que revierta los cambios de un commit en específico
- `git rm -r --cached .` → Remueve del Index. lo mencionado en gitignore. Suele usarse para ignorar lo que ya estaba indexado en el pasado
- `git show [id commit]` → Ver información detallada del último Commit (Log + DIff)
- `git stash` → Manda los cambios del área de trabajo al área de Stash
- `git stash --include-untracked` → Stash incluyendo lo que no ha sido agregado al trackeo
- `git stash --list` → Listar stash
- `git stash pop` → Retoma el último de la pila al área de trabajo
- `git stash pop stash@{1}` → Retoma desde stash de una posición específica
- `git stash save ["Nombre"]` → Mandar a Stash con nombre
- `git status` → Revisar el estado
- `git status -s` →Información de las ramas y de las áreas en versión reducida
- `git switch -c [nombreDeLaRama]` → Crear nueva rama
- `git switch [rama]` → Navegar entre ramas

### Extras
- `basename -s .git "$(git config --get remote.origin.url)"` -> Ver el nombre del repo
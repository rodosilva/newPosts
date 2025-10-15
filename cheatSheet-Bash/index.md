+++
date = '2025-02-04T19:55:05-05:00'
title = 'CheatSheet Bash'
+++

## 1. OBJETIVO
La idea de este Post es tener a la mano tanto comandos útiles de Linux como también mostrar la correcta sintaxis de scripts en Bash.

## 2. COMANDOS ÚTILES - EJEMPLOS

### - Comando: sed
**Filtrar y transformar texto**

En este ejemplo lo voy a combinar con el comando `cat` para así filtrar y transformar la salida o resultado del primer comando.

El objetivo es eliminar los números y quedarnos simplemente con las palabras.

Contenido del archivo `abc.txt`:
```bash
manzana roja
pera verde
plátano amarillo
3458452 8456325
zanahoria anaranjado
7542125 4785365
```
Ejecutamos:
```bash
cat abc.txt | sed -E 's/[0-9]+/''/g'
```
Resultado:
```bash
manzana roja
pera verde
plátano amarillo
 
zanahoria anaranjado

```
He utilizado el `-E` para poder añadir un `regex Extended` y así sustituir (`s/`) los números del `0 al 9` (Uno o más `+`) por un carácter vacío `''`. Con el `/g` le digo que abarque todo el archivo de texto `abc.txt`.

### - Comando: awk
**Escaneo y procesamiento de texto**
Voy a utilizar el mismo archivo `abc.txt` para así extraer la palabra o palabras basándome en filas y columnas.

Contenido del archivo `abc.txt`:
```bash
manzana roja
pera verde
plátano amarillo
3458452 8456325
zanahoria anaranjado
7542125 4785365
```
Ejecutamos:
```bash
cat abc.txt | awk 'FNR == 3 {print $1, $2}'
```
Resultado:
```bash
plátano amarillo
```
Con el `FNR` le digo que quiero dirigirme a la tercera `3` fila y deseo imprimir la columna `1` y `2`.
Nótese que luego de la `,` hay un espacio, es por eso que se respeta el espacio en blanco entre la palabra de la columna `1` y la de la columna `2`.

### - Comando: perl
**Escanear y extraer información**

Algo sumamente útil que se puede realizar con el comando `perl` es extraer un octeto de una dirección `IPv4`.

Por ejemplo:
```bash
echo "192.168.1.100" | perl -pe 's/(\d+)\.(\d+)\.(\d+)\.(\d+)/$4/g'
```
Resultado:
```bash
100
```
Con el `p` le digo que haga un loop pero con un formato parecido al de `sed` y con el `e` simplemente es para que sea una línea de comando.

Una vez generado el patron en un formato `regex` le digo que extraiga el cuarto `4` basándose en ese mismo patrón.

## 3. CONDICIONALES
### 3.1 Forma Básica
```bash
if [[ -z $string ]]; then
  echo "String is empty"
elif [[ -n $string ]]; then
  echo "String is not empty"
else
  echo "This never happens"
fi
```

### 3.2 Cuadro de Flags
| Condición                | Descripción           |
| ------------------------ | --------------------- |
| `[[ -z STRING ]]`        | String vacío          |
| `[[ -n STRING ]]`        | String no vacío       |
| `[[ -e FILE ]]`          | Archivo existe        |
| `[[ -r FILE ]]`          | Archivo de lectura    |
| `[[ -h FILE ]]`          | Es un Symlink         |
| `[[ -d FILE ]]`          | Directorio            |
| `[[ -w FILE ]]`          | Archivo de escritura  |
| `[[ -f FILE ]]`          | Es un archivo regular |
| `[[ -x FILE ]]`          | Es ejecutable         |
| `[[ STRING == STRING ]]` | Igual                 |
| `[[ STRING != STRING ]]` | No igual              |
| `[[ NUM -eq NUM ]]`      | Igual                 |
| `[[ NUM -ne NUM ]]`      | No igual              |
| `[[ NUM -lt NUM ]]`      | Menor que             |
| `[[ NUM -le NUM ]]`      | Menor o igual         |
| `[[ NUM -gt NUM ]]`      | Mayor que             |
| `[[ NUM -ge NUM ]]`      | Mayor o igual         |
| `[[ STRING =~ STRING ]]` | Regexp                |
| `(( NUM < NUM ))`        | Condición numérica    |
## 4. LOOP

### 4.1 For
Iterando un arreglo:
```bash
arreglo=(uno dos tres cuatro cinco)
# Iterando valores
for i in ${arreglo[@]}; do
  echo $i
done

# Iterando índices
for i in ${!arreglo[@]}; do
  echo $i
done
```

### 4.2 While
Lectura de archivo linea a linea
```bash
while read -r line; do
  echo "$line"
done <file.txt
```

## 5. SELECT AND CASE
Se suele utilizar para realizar menus

```bash
options=(toyota nissan honda mazda suzuki)

select op in "${options[@]}"
do
  case $op in
    toyota)
      echo "You selected Toyota"
      ;;
    nissan)
      echo "You selected Nissan"
      ;;
    honda)
      echo "You selected Honda"
      ;;
    mazda)
      echo "You selected Mazda"
      ;;
    suzuki)
      echo "You selected Suzuki"
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
  esac
done
```

## 6. ARREGLOS
```bash
Fruits=('Apple' 'Banana' 'Orange')
```

| echo            | output                |
| --------------- | --------------------- |
| "${Fruits[0]}"  | "Apple"               |
| "${Fruits[1]}"  | "Banana"              |
| "${Fruits[2]}"  | "Orage"               |
| "${Fruits[@]}"  | "Apple Banana Orange" |
| "${Fruits[-1]}" | "Orange" #Último      |
| "${#Fruits[@]}" | 3 #NumElementos       |
| "${!Fruits[@]}" | "0 1 2" #Índices      |
## 7. DICCIONARIOS

```bash
declare -A sounds

sounds[dog]="bark"
sounds[cow]="moo"
sounds[bird]="tweet"
sounds[wolf]="howl"
```

| echo             | output                |
| ---------------- | --------------------- |
| "${sounds[dog]}" | "bark"                |
| "${sounds[@]}"   | "bark tweet moo howl" |
| "${!sounds[@]}"  | "dog bird cow wolf"   |
| "${#sounds[@]}"  | 4 #NumElementos       |

## 8. RE-DIRECCIÓN

```bash
python hello.py > output.txt            # stdout to (file)
python hello.py >> output.txt           # stdout to (file), append
python hello.py 2> error.log            # stderr to (file)
python hello.py 2>&1                    # stderr to stdout
python hello.py 2>/dev/null             # stderr to (null)
```

## 9. VARIABLES ESPECIALES

| Variable | Significado                                            |
| -------- | ------------------------------------------------------ |
| $?       | Estado de la última tarea ejecutada ("0" Ok "1" Error) |
| $0       | Nombre del archivo de Script                           |
## 10. FUNCIONES

```bash
myfunc() {
    echo "hello $1"
}

myfunc "world"
```

El resultado diría:
`hello world`

| Elemento | Significado                                     |
| -------- | ----------------------------------------------- |
| $#       | Número de argumentos                            |
| $*       | Todos los argumentos de posición                |
| $@       | Todos los argumentos de posición con separación |
## 11. EJEMPLOS PRÁCTICOS
Aquí un ejemplo que toma `2` archivos que contengan algún tipo de lista (línea por línea) y la compara.
- Primero los ordena alfabéticamente sin importar las mayúsculas `sort -f`
- Luego pasa todo a minúsculas
- Luego elimina cualquier espacio en blanco tanto delante como al final de la línea dentro del mismo archivo `sed -i`
- Finalmente compara y muestra lo que se encontré solo en la primera lista `comm -23`, solo en la segunda lista `comm -13` y lo que tienen en común `comm -12`

```bash
#!/usr/bin/env bash

## The idea of this scripts is to compare a couple of files that list something line by line
list1=$1
list2=$2

## Sort
sort -f $list1 > "sorted_list1.tmp"
sort -f $list2 > "sorted_list2.tmp"

## All in lower case
tr '[:upper:]' '[:lower:]' < sorted_list1.tmp > sorted_lower_list1.tmp
tr '[:upper:]' '[:lower:]' < sorted_list2.tmp > sorted_lower_list2.tmp

## Remove white spaces and the beginning and end
sed -i 's/^[[:space:]]*//;s/[[:space:]]*$//' sorted_lower_list1.tmp
sed -i 's/^[[:space:]]*//;s/[[:space:]]*$//' sorted_lower_list2.tmp

sorted_list1="sorted_lower_list1.tmp"
sorted_list2="sorted_lower_list2.tmp"

## Beginning Comparison
echo "======================="
echo "Unique to: $1"
echo "======================="
comm -23 $sorted_list1 $sorted_list2

echo "======================="
echo "Unique to: $2"
echo "======================="
comm -13 $sorted_list1 $sorted_list2

echo "======================="
echo "Have in Common"
echo "======================="
comm -12 $sorted_list1 $sorted_list2
```
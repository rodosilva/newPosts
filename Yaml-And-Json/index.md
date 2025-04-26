+++
date = '2025-04-13T11:14:14-05:00'
title = 'Yaml And Json'
+++

## INTRODUCCIÓN
### Comparativa
![](Pasted%20image%2020250413111532.png)

## YAML
### Clave Valor (Key Value Pair)
```yaml
Fruta: Manzana
Vegetal: Zanahoria
Líquido: Agua
Carne: Pollo
```
### Arreglo o Lista (Array)
```yaml
Frutas:
- Naranja
- Manzana
- Plátano
Vegetales:
- Zanahoria
- Coliflor
- Tomate
```

### Diccionario (Dictionary/Map)
```yaml
Plátano:
  Calorías: 105
  Grasas: 0.4 g
  Carbs: 27 g

Uvas:
  Calorías: 62
  Grasas: 0.3 g
  Carbs: 16 g
```

### Espacios
No es posible tener `Mapping Values` dentro de una `Key` que ya tiene asignado un `Value`

Ejemplo:
```yaml
plátano:
  Calorías: 105
    Grasas: 0.4 g
    Carbs: 27 g
```
En ese caso `Calorías` ya tiene asignado el valor `105`. Es por ello que no se le puede asignar a su vez valores como `Grasas` y `Carbs`

### YAML Avanzado
Naturalmente podemos combinar Listas y Diccionarios
```yaml
Frutas:
  - Plátano:
      Calorías: 105
      Grasas: 0.4 g
      Carbs: 27 g
  - Uvas:
      Calorías: 62
      Grasas: 0.3 g
      Carbs: 16 g
```

### Diccionario Vs Listas Vs Listas de Diccionarios
La necesidad dependerá de si tenemos un solo ítem o a lo mejor más de un ítem de una misma categoría o tipo.
Por ejemplo:
![](Pasted%20image%2020250413114343.png)
Podría representarse en un YAML con un diccionario dentro de un diccionario:
```yaml
Color: Azul
Modelo:
  Nombre: Corvette
  Año: 1995
Transmisión: Manual
Precio: $20000
```

Ahora, que pasaría si tenemos varios ítems del mismo tipo de objecto.
En ese caso usaríamos listas con diccionarios dentro de diccionarios:

Es decir, de una lista como esta:
```yaml
- Corvette Azul
- Corvette Gris
- Corvette Rojo
- Corvette Verde
```

Pasaríamos a una lista con diccionarios (que a su vez puede contener otros diccionarios)
```yaml
-  Color: Azul
   Modelo:
      Nombre: Corvette
      Año: 1995
    Transmisión: Manual
    Precio: $20000

-  Color: Gris
   Modelo:
     Nombre: Corvette
     Año: 2005
   Transmisión: Manual
   Precio: $15000

-  Color: Rojo
   Modelo:
     Nombre: Corvette
     Año: 2015
   Transmisión: Automática
   Precio: $30000

-  Color: Verde
   Modelo:
     Nombre: Corvette
     Año: 2025
   Transmisión: Automática
   Precio: $40000
```

### Notas Finales
- **Diccionarios:** No importa el orden de la secuencia
```yaml
plátano:
  Calorías: 105
    Grasas: 0.4 g
    Carbs: 27 g
```
Es igual a:
```yaml
plátano:
  Calorías: 105
    Cargs: 27 g
    Grasas: 0.4 g
```

- **Listas:** Sí importa el orden de la secuencia
```yaml
Frutas:
- Naranja
- Manzana
- Plátano
```
No es igual al
```yaml
Frutas:
- Naranja
- Plátano
- Manzana
```

## YAML VS JSON
- YAML
```yaml
carro:
  color: azul
  precio: $20000
```

```yaml
carro:
  color: azul
  precio: $20000
  aros:
    - modelo: X3
      ubicación: frontal
    - modelo X4
      ubicación: trasera
```


- JSON
```json
{
  "carro": {
    "color": "azul",
    "precio": "$20000"
  }
}
```

```json
{
  "carro": {
    "color": "azul",
    "precio": "$20000",
    "aros": [
      {
        "modelo": "X3",
        "ubicacion": "frontal"
      },
      {
        "modelo": "X4",
        "ubicación": "trasera"
      }
    ]
  }
}
```

> Herramienta de conversión: [json2yaml](https://www.json2yml.com/#/)

## JSON PATH
#### JSON Path Diccionarios
- **Root Element** `$`: Se le conoce al nombre del diccionario raíz

Considerando este archivo `JSON`
```json
{
  "vehículos": {
    "carro": {
      "color": "azul",
      "precio": "$20000"
    },
    "bus": {
      "color": "blanco",
      "precio": "$120000"
    }
  }
}
```


| Query                    | Resultado                                                           |
| ------------------------ | ------------------------------------------------------------------- |
| `$.vehículos.carro`      | [<br>  {<br>    "color": "azul",<br>	"precio": "$20000"<br>  }<br>] |
| `$.vehículos.bus.precio` | [<br>  "$120000"<br>]                                               |
#### JSON Path Listas
Considerando este archivo `JSON`
```json
[
  "carro",
  "bus",
  "camión",
  "bicicleta"
]
```


| Query    | Resultado                  |
| -------- | -------------------------- |
| `$[0]`   | `[ "carro" ]`              |
| `$[3]`   | `[ "bicicleta" ]`          |
| `$[0,3]` | `[ "carro", "bicicleta" ]` |
#### JSON Path Diccionarios & Listas
Considerando este archivo `JSON`
```json
{
  "carro": {
    "color": "azul",
    "precio": "$20000",
    "aros": [
      {
        "modelo": "X3",
        "ubicación": "frontal"
      },
      {
        "modelo": "X4",
        "ubicación": "trasera"
      }
    ]
  }
}
```


| Query                    | Resultado |
| ------------------------ | --------- |
| `$.carro.aros[1].modelo` | `X4`      |
#### JSON Path Criterio
Considerando este archivo `JSON`
```json
[
  12,
  43,
  23,
  12,
  56,
  43,
  93,
  32,
  45,
  63,
  27,
  8,
  78
]
```


| Query                                               | Resultado                                              |
| --------------------------------------------------- | ------------------------------------------------------ |
| `$[?( @ > 40 )]`                                    | [<br>43,<br>56,<br>43,<br>93,<br>45,<br>63,<br>78<br>] |
| `$[?( in [40,43,45] )]`                             | [<br>43,<br>45<br>]                                    |
| `$.carro.aros[?( @.ubicación == "trasera")].modelo` | `X4`                                                   |
- `?`: Significa que usaremos un criterio (check)
- `@`: Significa cada item dentro de la lista
- `>`: Mayor que
- `==`: Igual a
- `!=`: Diferente a
- `in`: Ya sea cualquiera de esos números
- `nin`: Ya sea diferente a cualquiera de esos números

> NOTA: En la práctica los comandos en la terminal serían así: `cat file.json | jpath '$[0,3]'`

## JSON PATH Wildcard
Considerando estos archivos `JSON`
```json
{
  "carro": {
    "color": "azul",
    "precio": "$20000"
  },
  "bus": {
    "color": "blanco",
    "precio": "$120000"
  }
}
```

```bash
[
  {
    "modelo": "X3",
    "ubicación": "frontal"
  },
  {
    "modelo": "X4",
    "ubicación": "trasera"
]
```

```json
{
  "carro": {
    "color": "azul",
    "precio": "$20000",
    "aros": [
      {
        "modelo": "X3"
      },
      {
        "modelo": "X4"
      }
    ]
  },
  "bus": {
    "color": "blanco",
    "precio": "$120000",
    "aros": [
      {
        "modelo": "Z3"
      },
      {
        "modelo": "Z4"
      }
    ]
  }
}
```

| Query                | Resultado                  |
| -------------------- | -------------------------- |
| `$.*.color`          | `["azul", "blanco"]`       |
| `$[*].modelo`        | `["X3", "X4"]`             |
| `$.*.aros[*].modelo` | `["X3", "X4", "Z3", "Z4"]` |
- `*`: Significa todos o cualquier propiedad del diccionario

## JSON PATH Lists

Considerando la data:
```json
[
  "Apple",
  "Google",
  "Microsoft",
  "Amazon",
  "Facebook",
  "Coca-Cola",
  "Samsung",
  "Disney",
  "Toyota",
  "McDonald's"
]
```


| Query                 | Resultado                                                      | Explicación                                                                                                 |
| --------------------- | -------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `$[0:8:2]`            | [<br>"Apple",<br>"Microsoft",<br>"Facebook",<br>"Samsung"<br>] | Del 0 al 8 (Sin considerar el 8)<br>Haciendo un salto                                                       |
| `$[-1:0]`<br>`$[-1:]` | [ "McDonald's" ]                                               | Empezando del último se le da un valor de `-1` luego `-2` y así en adelante hasta el `-10` (Para este caso) |
| `$[-3:]`              | [<br>"Disney",<br>"Toyota",<br>"McDonald's"<br>]               |                                                                                                             |

## JSON PATH en Kubernetes
1. Identificar el comando `kubectl`: `kubectl get pods`
2. Reconocer la salida en formato `JSON`: `kubectl get pods -o json`
3. Realizar la consulta en `JSON PATH`(No es necesario usar el `$`): `.items[0].spec.containers[0].image`
4. Combinar el `kubectl` con `JSON PATH`: `kubectl get pods -o=jsonpath='{ .items[0].spec.containers[0].image }'`

### Otros ejemplos
Del archivo `yaml`:
```json
{
  "apiVersion": "v1",
  "items": [
    {
      "apiVersion": "v1",
      "kind": "Node",
      "metadata": {
        "name": "master"
      },
      "status": {
        "capacity": {
          "cpu": "4"
        },
        "nodeInfo": {
          "architecture": "amd64",
          "operationgSystem": "linux",
        }
      }
    },
    {
      "apiVersion": "v1",
      "kind": "Node",
      "metadata": {
        "name": "node01",
      },
      "status": {
        "capacity": {
          "cpu": "4",
        },
        "nodeInfo": {
          "architecture": "amd64",
          "operationgSystem": "linux",
        }
      }      
    }
  ],

...
```

- `kubectl get pods -o=jsonpath='{.items[*].metadata.name}'`
```
master node01
```
- `kubectl get pods -o=jsonpath='{.items[*].status.nodeInfo.architecture}'`
```
amd64 amd64
```
- `kubectl get pods -o=jsonpath='{.items[*].status.capacity.cpu}'`
```
4 4
```
- `kubectl get pods -o=jsonpath='{.items[*].metadata.name}{.items[*].status.capacity.cpu}'`
```
master node01 4 4
```
- `kubectl get pods -o=jsonpath='{.items[*].metadata.name}{"\n"}{.items[*].status.capacity.cpu}'`
```
master node01
4 4
```
-  `kubectl get pods -o=jsonpath='{.items[*].metadata.name}{"\t"}{.items[*].status.capacity.cpu}'`
```
master node    4 4 
```

### Loops - Range
Similar al uso de `for each`
- `kubectl get nodes -o=jsonpath='{range .items[*]}{metadata.name}{"\t"}{.status.capacity.cpu}{\"n"}{end}'`

```
master    4
node01    4
```

### JSON PATH para columnas personalizadas
Considerando que queremos una columna llamada `NODE` y otra `CPU`
- `kubectl get nodes -o=custom-columns=NODE:.metadata.name ,CPU:.status.capacity.cpu`
```
NODE    CPU
master  4
node01  4
```

> NOTA: no es necesario colocar el `items[*]`

### JSON PATH Ordenar por
Usando el `sort-by`
- `kubectl get nodes --sort-by= .metadata.name`
```
NAME    STATUS    ROLES    AGE  VERSION
master  Ready     master   5m   v1.11.3 
node01  Ready     <none>   5m   v1.11.3
```



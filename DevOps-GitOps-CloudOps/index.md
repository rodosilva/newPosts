+++
date = '2025-09-20T12:42:11-05:00'
title = 'DevOps GitOps & CloudOps'
+++

## DevOps

### Prueba de Integración
Para poder entender qué es una prueba de integración o `Integration Testing`, primero debes conocer lo que es una `Unit Testing`.

`Unit Testing` es una prueba realizada al código de una aplicación. Pero esta se aplica solamente a una unidad en particular. Es decir es una prueba aislada a un módulo o unidad del programa en general.

Ahora `Integration Testing` sería el siguiente paso. Una o varias pruebas que se basan en la funcionalidad en conjunto de la suma de las unidades, asegurando la funcionalidad de mismas trabajando juntas.

#### Aproximación Big Ban
Se basa en verificar todos los módulos en una, luego de completar la revisión individual de cada módulo. 
#### Aproximación Top Down and Bottom Up
Se basa en el uso de `dummy modules` para simular data que fluye entre módulos.
### CI/CD Conceptos Y Alcances
Es un flujo de trabajo automatizado `DevOps` que agiliza los procesos de entrega de software.

#### CI: Integración continua
Automáticamente construye, prueba e integra cambios en el código dentro de repositorios compartidos.
El alcance de este etapa suele llegar hasta la entrega del artefacto o binario.

#### CD: Entrega continua
Entrega automáticamente código a entornos tipo `Stage` (Listo para producción). Y queda a la espera de alguna aprobación posiblemente manual.
El alcance de esta etapa suele llegar hasta la entrega del artefacto a algún repositorio tipo `Docker Hub` o `Artifactory`

#### Despliegue continuo (Continuous Deployment)
la parte `CD` de `CI/CD` suele hacer referencia a la entrega continua. En cambio el despliegue continuo suele tener algún paso manual de aprobación. Puesto que esto ya es un pase a producción (A veces puede hacer referencia a un pase a servidores de`testing`).

### Estrategias de Git Branching
Las estrategias de Git branching son como rutas o caminos que usan para organizar el trabajo, hacer seguimiento a las versiones y lograr un trabajo conjunto en el trabajo de control de versiones.

#### Trunk-Based Development
Puede darse casos de `commit` que van directo a la rama `main`, o ramas pequeñas creadas específicas para algo en particular que son `merged` rápidamente.
Presenta ramas de corta vida como: `/task/{{id}}` o `/fix/1234`

![](Pasted%20image%2020250921093921.png)

- Escenarios de CI/CD
- Equipos ágiles
- Cierto riesgo de inestabilidad
- Se requiere disciplina y una buena revisión de código

#### Feature Branching
Cada prestación o `Bug fix` se desarrolla en su propia rama. Una vez completado el desarrollo se une a la rama `main`

![](Pasted%20image%2020250921094929.png)
- Equipos que necesitan tener las prestaciones claras
- Minimiza el peligro a romper producción
- Necesita una constante actualización de las ramas
- Puede presentar conflictos de `merge`

#### Release Branching
Ramas separadas que se mantienen para cada `release` versión.
![](Pasted%20image%2020250921095839.png)
- Se usa en proyectos con soporte de largo plazo (LTS)
- Brinda un historial claro de cada `release`.
- Difícil manejo de ramas
- No ideal para proyectos que requiera velocidad.
- Se suele usar para proyectos con pocos `deployments`

#### Github Flow
Es un flujo simplificado para ser orientado hacia la entrega continua.
Se basa en ramas `feature` de corta vida que luego son integradas a la rama `main`.
![](Pasted%20image%2020250921111621.png)
- Se suele utilizar en equipos que quieren integrar CI/CD
- Proyectos cortos de alta velocidad
- Puede presentar inestabilidad, dado que la rama `main` debe estar siempre lista para producción.
#### GitFlow
Es una estrategia sumamente estructurada que utiliza multiples ramas como `main`, `develop`, `feature`, `release` y `hotfix`.
Requiere un buen uso del `naming convention` para las ramas: 
- Feature: `/feature/{{author}}/{{card-number}}/{{short-description}}`
- Hotfix: `/hotfix/{{issue-number}}`
- Release: `/release/{{version}}`

![](Pasted%20image%2020250921101152.png)
- Proyectos grandes y complejos que requieren mucha estabilidad.
- Los roles y las responsabilidades están bien definidas.
- Presenta complejidad y requiere un fuerte seguimiento de reglas
- No es ideal para necesidades de despliegue continuo.

#### Environment Branching
Es parecida a la **GitFlow** con la característica de tener una rama para cada entorno como`production`, `stage`, `dev`. Y a su vez también tiene los `release branches`, etc.
- Asume que necesitamos una rama para cada entorno
- 
### Estrategias de Despliegue
Se basa en las formas del pase a producción de nuestro código.

#### Big Bang Deployment
El pase se basa básicamente en apagar un sistema para luego prender la nueva versión.
Presenta complicaciones en caso se de alguna falla durante o luego del pase. Por lo que se tendría que hacer `rollback`.
Necesita tener un buen plan de `rollback`.

#### Rolling Deployment
El cambio se da de forma incremental con el tiempo.
![](Pasted%20image%2020250921114018.png)
El despliegue de la nueva versión se da gradualmente por lo que se va actualizando un server a la vez.
Usualmente previene caídas de servicio para los usuarios. Sin embargo no permite realizar `targeted Rollouts` hacia un grupo específico de usuarios.

#### Blue-Green Deployment
Se basa en tener dos sistemas idénticos, el `Blue` y el `Green`.
![](Pasted%20image%2020250921115006.png)
El `Blue` suele estar como activo, mientras que el `green`, como inactivo.

El `Green` termina siendo como nuestro `playground` donde se puede desplegar y probar las nuevas versiones. Los colaboradores de `Q&A` suelen apuntar siempre al `Green`.

Cuando `Green` se considera como listo, se hace que todos los usuarios apunten a este entorno. Es decir `Green`pasa a ser el activo.

Ahora el `Blue` pasa a estar inactivo y termina siendo un entorno de respaldo.

No se suele poder dirigir a un grupo específico de usuarios hacia la nueva versión una vez hecho el cambio. Además es una infraestructura compleja que consume muchos recursos.

#### Canary Deployment
Se basa en probar la nueva versión pero de una forma gradual y controlada.
Ejemplo: `Rolled Out al 10%`
Puede ser ir cambiando la versión de los servidores poco a poco, como también ir desviando a cierto grupo de usuarios para tener un entorno de producción pero a una escala menor.
![](Pasted%20image%2020250921120656.png)
En caso de falla simplemente se puede volver a desviar a los usuarios de regreso al grupo de servidores anterior. Es decir este método si permite `Targeted Rollouts` con lo que se puede usar diferentes criterios de selección como localización geográfica o tipo de dispositivos.

Sí requiere herramientas complejas de infraestructura como monitoreo y pruebas automatizadas.

`Canary Deployment` se suele utilizar en conjunto con otras estrategias de despliegue como por ejemplo `Rolling Deployment`

#### Feature Toggle
No se basa necesariamente en pasar toda la aplicación a una nueva versión.
Sino más bien, manejar prestaciones específicas dentro de la aplicación.

![](Pasted%20image%2020250921122048.png)

Entonces se puede prender o apagar ciertas `features` a disposición para ciertos usuarios o bajo ciertas circunstancias.

También puede ser usado en combinación con cualquier otra estrategia de despliegue.

Ofrece mucho control sobre quien puede acceder a esas nuevas `features`. Es decir permite el `Targeted user testing` o `A/B testing`

## GitOps
`GitOps` toma las prácticas de `DevOps` y las aplica a la automatización de infraestructura (Infrastructure as a Code).

Entonces diferentes colaboradores puede hacer `Push` desde los repositorios hacia la infraestructura para así realizar cambios en ella bajo una especie de control de versiones.

Pero así como hay un `Push` también existe un `Pull`. Que está constantemente leyendo la infraestructura para poder compararla con lo que se tiene el los repositorios.

![](Pasted%20image%2020250920162206.png)

Y gracias a herramientas tales como `ArgoCD`, se consigue que `Git` sea la fuente de la verdad (source of truth). 
Esto significa que `ArgoCD` es capaz de detectar cualquier cambio en la infraestructura (algún posible cambio manual) y si esta es diferente al repositorio de `git`, lo revierte nuevamente tal y como está definido en el repositorio. 

## CloudOps

## SysAdmin



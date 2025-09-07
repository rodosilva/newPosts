+++
date = '2025-03-23T20:32:16-05:00'
title = 'Kubernetes Administrator CKA'
+++

## PODS
### Imperativo
`kubectl run myapp-pod --image=nginx --dry-run=client -o yaml > myapp-pod.yaml` 
Construye un archivo yaml que hace referencia a un pod con la imagen descrita
### Declarativo
```bash
apiVersion: v1
kind: Pod
metadata:
    name: myapp-pod
    labels:
        app: myapp
        type: front-end    
spec:
    containers:
        - name: nginx-container
          image: nginx
```

### Init Container Vs SideCar Container
- **Init Container:** Contenedores que corren hasta completar su tarea durante la iniciación del POD
- **SideCar Container:** Contenedor que inicia antes de la aplicación principal pero se mantienen corriendo.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app.kubernetes.io/name: MyApp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', "until nslookup myservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for myservice; sleep 2; done"]
  - name: init-mydb
    image: busybox:1.28
    command: ['sh', '-c', "until nslookup mydb.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for mydb; sleep 2; done"]
```
**_NOTA:_** Ejemplo de `Init Container`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  labels:
    app: myapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: myapp
          image: alpine:latest
          command: ['sh', '-c', 'while true; do echo "logging" >> /opt/logs.txt; sleep 1; done']
          volumeMounts:
            - name: data
              mountPath: /opt
      initContainers:
        - name: logshipper
          image: alpine:latest
          restartPolicy: Always
          command: ['sh', '-c', 'tail -F /opt/logs.txt']
          volumeMounts:
            - name: data
              mountPath: /opt
      volumes:
        - name: data
          emptyDir: {}
```
**_NOTA:_** Ejemplo de `SideCar Container`
## DEPLOYMENT
### Imperativo
`kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml`

### Declarativo
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
    name: myapp-deployment
    labels:
        app: myapp
        type: front-end    
spec:
    template:
        metadata:
          name: myapp-pod
          labels:
             app: myapp
             type: front-end    
        spec:
          containers:
          - name: nginx-container
            image: nginx
replicas: 3
selector: 
    matchLabels:
        type: front-end
```

## DAEMONSETS
Ayuda a desplegar multiples instancias de PODs
Corre una copia de tu POD en cada nodo de tu cluster
Con cada nodo nuevo, se añade una replica
También asegura que una copia del POD este siempre presente en todos los nodos.
### Declarativo
```bash
apiVersion: apps/v1
kind: DaemonSet
metadata:
    name: monitoring-daemon
 spec:
     selector:
         matchLabels:
             app: monitoring-agent
     template:
         metadata:
             labels:
                 app: monitoring-agent
         spec:
             containers:
                 - name: monitoring-agent
                   image: monitoring-agent

```

## SERVICES
### Node Port
![](Pasted%20image%2020250323210547.png)
```bash
apiVersion: v1
kind: Service
metadata:
    name: myapp-service
spec:
    type: NodePort
    ports:
        - targetPort: 80
          port: 80
          nodePort: 30008
    selector:
        app: myapp
        type: front-end
```

También se puede realizar de forma **imperativa:**
```bash
kubectl expose pod myapp --type=NodePort --port=80 --name=myapp-service --dry-run=client -o yaml
```
### Cluster IP
Servicio de Kubernetes que nos permite agrupar los PODs y proporcionar una sola interface de acceso hacia los PODs
![](Pasted%20image%2020250323210857.png)

```bash
apiVersion: v1
kind: Service
metadata:
    name: back-end
spec:
    type: ClusterIP
    ports:
        - targetPort: 80
          port: 80
                    
    selector:
        app: myapp
        type: back-end
```

### LoadBalancer
```bash
apiVersion: v1
kind: Service
metadata:
    name: myapp-service
    
 spec:
     type: LoadBalancer
     ports:
         - targetPort: 80
         port: 80
         nodePort: 30008
```
Soporte en: AWS, Azure, GoogleCloud

## CONFIGMAP
### Imperativo
- `kubectl create configmap app-config --from-literal=APP_COLOR=blue --from-literal=APP_MOD=prod`
- `kubectl create configmap <config-name> --from-file=<path-to-file>`

### Declarativo
```bash
# config-map.yaml

apiVersion: v1
kind: ConfigMap 
metadata:
    name: app-config # <<<<<<<<<<<--- HERE
data:
    APP_COLOR: blue
    APP_MODE: prod 
```

#### Inject into a POD
```bash
# pod-definition.yaml
apiVersion: v1
kind: Pod
metadata:
    name: simple-webapp-color
    labels:
        name: simple-webapp-color
spec:
    containers:
        - name: simple-webapp-color
          image: simple-webapp-color
          ports:
              - containerPort: 8080
          envFrom:
              - configMapRef:
                  name: app-config # <<<<<--- HERE
```

## SECRETS
### Imperativo
Creamos varios `secrets` de forma implícita:
`kubectl create secret generic app-secret --from-literal=DB_Host=mysql --from-literal=DB_User=root --from-literal=DB_Password=paswrd`

También podemos crear desde un archivo:
`kubectl create secret generic app-secret --from-file=app_secret.properties`

### Declarativo
```yaml
# secre-data.yaml

apiVersion: v1
kind: Secret
metadata:
    name: app-secret
data:
    DB_Host: bx1zcWw=
    DB_User: cm9vda==
    DB_Password: cGFzd3Jk
```

> **_NOTA:_** Para codificar (encode): `echo -n 'mysql' | base64` y para decodificar `echo -n 'bx1zcWw=' | base64 --decode`

### Secrets en los PODs
```yaml
# pod-definition.yaml
apiVersion: v1
kind: Pod
metadata:
    name: simple-webapp-color
    labels:
        name: simple-webapp-color
spec:
    containers:
        - name: simple-webapp-color
          image: simple-webapp-color
          ports:
              - containerPort: 8080
          envFrom:
              - secretRef:
                  name: app-secret # <<< HERE
```

En el `env` cuando necesito solo una variable
```yaml
env:
    - name: DB_Password
      valueFrom:
          secretKeyRef:
              name: app-secret
              key: DB_Password
```

En el `volumes`
```yaml
volumes:
    - name: app-secret-volume
      secret:
          secretName: app-secret
```

Donde `app-secret-volume` podría ser un directorio que contiene archivos con los `secrets`
## REPLICASET
Alta disponibilidad

### Declarativo

#### Replication Controller
```bash
apiVersion: v1
kind: ReplicationController
metadata:
    name: myapp-rc
    labels:
        app: myapp
        type: front-end    
spec:
    template:
        metadata:
          name: myapp-pod
          labels:
             app: myapp
             type: front-end    
        spec:
          containers:
          - name: nginx-container
            image: nginx
replicas: 3
```

#### Replica Set (Evolución del Replica Controller)
```bash
apiVersion: apps/v1
kind: ReplicaSet
metadata:
    name: myapp-replicaset
    labels:
        app: myapp
        type: front-end    
spec:
    template:
        metadata:
          name: myapp-pod
          labels:
             app: myapp
             type: front-end    
        spec:
          containers:
          - name: nginx-container
            image: nginx
replicas: 3
selector: 
    matchLabels:
        type: front-end 
```

### Labels Y Selector
Para relacionar el `POD` con el `ReplicaSet` debemos usar el mismo valor tanto en el `labels` del `POD` como en el `selector` del `ReplicaSet`.
```
#pod-definition.yml

metadata:
    name: myapp-pod
    labels:
        tier.front-end
        
#replicaset-definition.yml
selector:
    matchlabels:
        tier.front-end 
```

## RBAC: ROLE BASED ACCESS CONTROL

### Role:
Regula el acceso basado en roles
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
    name: developer
    namespace: [nameSpaceName]
rules:
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["list", "get", "create", "update", "delete"]
      resourceNames: ["blue", "orange"] #Specific Pods 
    - apiGroups: [""]
      resources: ["configMap"]
      verbs: ["create"]
```

Y de forma imperativa la creación del **Role** sería:
`kubectl create role developer --ver=list,create,delete --resource=pods`

### Binding Role and User:
Para hacer el link entre el **Role** y el **User**:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
    name: devuser-developer-binding
subjects:
     - kind: User
       name: dev-user
       apiGroup: rbac.authorization.k8s.io
roleRef:
    kind: Role
    name: developer
    apiGroup: rbac.authorization.k8s.io
```

Y de forma imperativa sería:
`kubectl create rolebinding dev-user-binding --role=developer --user=dev-user`

### Revisar Acceso:
Se puede probar acceso:
`kubectl auth can-i create pods --as dev-user --namespace test`

### Cluster Roles:
En este caso los roles y los `Role Bindings` son creados dentro de `namespaces`
![](Pasted%20image%2020250904214737.png)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
    name: cluster-administrator
rules:
    - apiGroups: [""]
      resources: ["nodes"]
      verbs: ["list", "get", "create", "delete"]
```

### Cluster Role Binding
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind:ClusterRoleBinding
metadata:
    name: cluster-admin-role-binding
subjects:
    - kind: User
      name: clister-admin
      apiGroup: rbac.authorization.k8s.io
roleRef:
    kind: ClusterRole
    name: cluster-administrator
    apiGroup: rbac.authorization.k8s.io
```


## COMMANDS & ARGUMENTS
Considerando la diferencia:
- **Command:** Es el comando per se. Ejemplo `command: ["sleep2.0"]`
- **Arg**: Es el argumento que acompaña al comando. Ejemplo `args: ["10"]`
Para este caso sería un `sleep` de `10` segundos.

### Alternativas
```yaml
# Option 1
command: ["sleep 5000"]

# Option 2
command:
    - "sleep"
    - "5000"
```

### Ejemplo
```yaml
# pod-definition.yaml
apiVersion: v1
kind: Pod
metadata:
    name: ubuntu-sleeper-pod
spec:
    containers:
        - name: ubuntu-sleeper
          image: ubuntu-sleeper
          command: ["sleep2.0"]
          args: ["10"]
```

## ENVIRONMENT VARIABLES
Existen dos formas de establecer variables de entorno.
Una es utilizando `env` y la otra, utilizando `envFrom`. Esta ultima establece la variable de entorno haciendo referencia a un [CONFIGMAP](#CONFIGMAP) o a un [SECRETS](#SECRETS).

Para este caso nos enfocaremos en `env`. Ejemplo:
```bash
apiVersion: v1
kind: Pod
metadata:
  name: envar-demo
  labels:
    purpose: demonstrate-envars
spec:
  containers:
  - name: envar-demo-container
    image: gcr.io/google-samples/hello-app:2.0
    env:
    - name: DEMO_GREETING
      value: "Hello from the environment"
    - name: DEMO_FAREWELL
      value: "Such a sweet sorrow"
```

También podemos utilizar campos del POD como valores para nuestras variables de entorno:
```bash
      env:
        - name: MY_NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
```
## ROLLOUT Y VERSIONING
Cuando creamos un `Deployment` automáticamente se dispara un `rollout`.
A su vez un `rollout` genera una nueva versión del `Deployment`.
Cada vez que se actualice la versión del contenedor, se genera un nuevo `rollout` lo que crea una nueva revisión del `Deployment`

- Para ver el estado: `kubectl rollout status deployment myapp-deployment`
- Para ver el historial: `kubectl rollout history deployment myapp-deployment`
### Annotate
Podemos colocar una nota del motivo del cambio (Ejemplo):
- `kubectl annotate deployments nginx-deploy kubernetes.io/change-cause="Updated nginx image to 1.17"`
### Strategy Type
- **Recreate**: Se destruyen todos los `PODs` antes de empezar a recrear los nuevos.
- **RollingUpdate**: (Por defecto) Se destruyen uno o algunos mientras se van creando los nuevos de forma secuencial. `.spec.strategy.type==RollingUpdate`
### Rollback
Para poder realizar un `rollback`:
- Rollback: `kubectl rollout undo deployment myapp-deployment`

## BACKUP & RESTORE
### Cluster ETCD
Para hacer uso del `etcdctl` necesitamos empezar asignando la variable de entorno:
`export ETCDCTL_API=3`

Durante el `snapshot` se necesitan colocar ciertos parámetros que los podremos encontrar en:
`/etc/kubernetes/manifests/etcd.yaml`
Necesitaremos tener a la mano:
- cacert: `--peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt`
- cert: `--cert-file=/etc/kubernetes/pki/etcd/server.crt`
- key: `--key-file=/etc/kubernetes/pki/etcd/server.key`
- datadir: `--data-dir=/var/lib/etcd`

Ya con eso podemos generar el `snapshot`:
```bash
# Exportamos la variable de entorno
export ETCDCTL_API=3

# Creamos el snapshot
etcdctl snapshot save snapshot.db --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key

# Revisamos el estado del snapshot
etcdctl snapshot status snapshot.db
# Nuevas versiones usan etcdutl
## etcdutl --write-out=table snapshot status snapshot.db
```

#### Restaurar
Para restaurar:
```bash
# Detenemos el servicio apiserver
service kube-apiserver stop

# Restauramos
export ETCDCTL_API=3
etcdctl --data-dir <data-dir-location> snapshot restore snapshot.db
# Nuevas versiones usan etcdutl
## etcdutl --data-dir <data-dir-location> snapshot restore snapshot.db

# Refrescar
systemctl daemon-reload
service etcd restart
service kube-apiserver start
```

## NETWORKING
### Instalación de Network Plugins
- `kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml` Weave Net
- `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml` Flannel
- `curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O` & `kubectl apply -f calico.yaml` Calico
- 

### DNS en Kubernetes
#### Sub Dominios

| Hostname    | Namespace | Type | Root          | IP Address    |
| ----------- | --------- | ---- | ------------- | ------------- |
| web-service | apps      | svc  | cluster.local | 10.107.37.188 |
| web         | apps      | pod  | cluster.local | 10.244.2.5    |
- FQDN: `web-service.apps.svc.cluster.local`, `web.apps.pod.cluster.local`
### Core DNS
Kubernetes usa `CoreDNS`. Es un Server DNS flexible y extensible que puede servir como un cluster DNS de Kubernetes.
- Archivo de configuración: `/etc/coredns/corefile`
- ConfigMap: `kubectl get configmap -n kube-system`
#### Recursos
- Service account: `coredns`
- Cluster-roles: `coredns` y `kubedns`
- Cluster role bindings: `coredns` y `kube-dns`
- Deployment: `coredns`
- Configmap: `coredns`
- Service: `kube-dns`
### Kube-Proxy
Mantiene las reglas de red en los nodos.
Estas reglas permiten la comunicación hacia los PODs desde las sesiones dentro o fuera del cluster.
- Archivo de configuración: `/var/lib/kube-proxy/config.conf`

### CNI en Kubernetes
La manera en que se aísla las redes es mediante `Namespaces`
Los podemos listar mediante el comando `ip netns` o ver a detalle con `ip netns exec [red] ip link`

#### Introducción
Se muestra una forma manual de establecer conexión de red entre diferentes redes virtuales:
```bash
# Crear un namespace
ip netns add [red]
# Detallarlo
ip -n red link
# Otra opción
ip netns exec [red] ip link
# Ver la tabla arp
arp
# Ver tabla arp para el namespace
ip netns exec [red] arp
# Ver tabla de enrutamiento
route
# Ver tabla de enrutamiento para el namespace
ip netns exec [red] route
```

Estableciendo conexión:
```bash
# Crear un veth
ip link add veth-red type veth
# Si deseamos crear un tunel entre veth
ip link add veth-red type veth peer name veth-blue
# Asignamos el veth a un namespace
ip link set veth-red netns red
# Asignamos una IP
ip -n red addr add 192.168.15.1 dev veth-red
# Levantamos el link
ip -n red link set veth-red up
# Por si queremos borrarlo
ip -n red link del veth-red
# Probamos mediante ping
ip netns exec red ping 192.168.15.2
```

Ahora toca configurar el `bridge` 
```bash
# Crear bridge
ip link add [v-net-0] type bridge
# Levantar el bridge
ip link set dev v-net-0 up
# Crear el peer del veth con un veth pero del Bridge
ip link add veth-red type veth peer name veth-red-br
# Asignarle IP al bridge
ip addr add 192.168.15.5/24 dev v-net-0
# Unir el veth del bridge al Bridge
ip link set veth-red-br master v-net-0
```

![](Pasted%20image%2020250902213727.png)

Para el **enrutamiento**
```bash
# Enrutamiento para una Red
ip netns exec [blue] ip route add 192.168.1.0/24 via 192.168.15.5
# Enrutamiento Default
ip netns exec blue ip route add default via 192.168.15.5
```

![](Pasted%20image%2020250902215145.png)

Finalmente el `NAT`
```bash
iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -j MASQUERADE
# Ingreso hacia Blue desde fuera
iptables -t nat -A PREROUTING --dport 80 --to-destination 192.168.15.2:80 -j DNAT
```

#### Forwarding
Es necesario que los `Nodos` re envíen los paquetes. Y eso está en:
```bash
# 0 es no forwarding
cat /proc/sys/net/ipv4/ip_forward
# 1 es forward
echo 1 > /proc/sys/net/ipv4/ip_forward
# Para que persista a pesar de los reinicios
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-iptables = 1' >> /etc/sysctl.conf
# Leer valores
sysctl -p
```
## INGRESS
Utilizando `services` del tipo `load balancer`para más de una aplicación bajo un mismo dominio tal como:
- `www.my-online-store.com/wear`
- `www.my-online-store.com/watch`
Terminaríamos teniendo más de un `load balancer`. Uno para el `deployment` de `wear` y otro para el de `watch`

`Ingress` se presenta como una solución para esto.
![](Pasted%20image%2020250814214757.png)
Primero necesitamos un `Ingress Controller` existen alternativas pero una de las más comunes es `NGINX`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: nginx-ingress-controller
 spec:
     replicas: 1
     selector:
         matchLabels:
             name: nginx-ingress
     template:
         metadata:
             labels:
                 name: nginx-ingress
         spec:
             containers:
                 - name: nginx-ingress-controller
                   image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
             args:
                 - /nginx-ingress-conttroller
                 - --configmap-$(POD_NAMESPACE)/nginx-configuration
             env:
                 - name: POD_NAME
                   valueFrom:
                       filedRef:
                           fieldPath: metadata.name
                 - name: POD_NAMESPACE
                   valueFrom:
                       fieldRef:
                           fieldPath: metadata.namespace  
             ports:
                 - name: http
                   containerPort: 80
                 - name: https
                   containerPort: 443
```

Vemos que tiene un `configmap` para poder pasar configuraciones desde un archivo aparte:

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
    name: nginx-configuration
```

Y debe tener su `service`:
```yaml
apiVersion: v1
Kind: Service
metadata:
    name: nginx-ingress
 spec:
     type: NodePort
     ports:
         - port: 80
           targetPort: 80
           protocol: TCP
           name: http
         - port: 443
           targetPort: 443
           protocol: TCP
           name: https
     selector:
         name: nginx-ingress
```

Y su `service Account`:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
    name: nginx-ingress-serviceaccount
```

Finalmente el `Ingress` 
```yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear-watch
  namespace: app-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /wear
        pathType: Prefix
        backend:
          service:
           name: wear-service
           port: 
            number: 8080
      - path: /watch
        pathType: Prefix
        backend:
          service:
           name: video-service
           port:
            number: 8080
```
Existen los llamados `annotations` con los que podemos añadir configuraciones adicionales.
## STORAGE
### Volumes Y VolumeMounts
La forma mas simple de usar volúmenes sería:
```yaml
apiVersion: v1
kind: Pod
metadata: 
    name: random-number-generator
spec:
    containers:
        - image: alpine
          name: alpine
          command: ["/bin/sh","-c"]
          args: ["shuf -i 0-100 -n 1 >> /opt/number.out;"]
          volumeMounts:
              - mountPath: /opt
                name: data-volume
    volumes:
        - name: data-volume
          hostPath:
              path: /data
              type: Directory
```
### Persistent Volumes
Son volúmenes que se crean para estar disponibles ante algún `persistent volume claim` para su uso.

Ya sea usando almacenamiento de `AWS`
```yaml
# pv-definition.yaml

apiVersion: v1
kind: PersistentVolume
metadata: pv-voll
spec:
    accessModes:
        - [ ReadWriteOnce ReadOnlyMany ReadWriteMany ]
    capacity:
        storage: 1Gi
    awsElasticBlockStore:
        volumeID: [volume-id]
        fsType: ext4
```

O almacenamiento local:
```yaml
# pv-definition.yaml example2

apiVersion: v1
kind: PersistentVolume
metadata:
    name: pv-log
spec:
    persistentVolumeReclaimPolicy: Retain
    accessModes:
        - ReadWriteMany
    capacity:
        storage: 100Mi
    hostPath:
      path: /pv/log
```

- `persistentVolumeReclaimPolicy: Retain`: Es el de defecto. Luego de ser borrado, el volumen se retiene
- `persistentVolumeReclaimPolicy: Deleted`: Luego de ser borrado, el volumen se borra
- `persistentVolumeReclaimPolicy: Recycle`: Luego de ser borrado, el volumen se recicla

### Persistent Volume Claims
Estos son los que solicitan para que los nodes adquieran almacenamiento
Dependerá de si el `persistent volume` tiene suficiente capacidad así como hacer `match` con el `accessModes`:

```
# pvc-definition.yaml

apiVersion: v1
kind: PersistentVolumeClaim
metadata: 
    name: myClaim
spec:
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
            storage: 500Mi
```

### Persistent Volume Claims en PODs

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```

### Storage Class
Le otorga al administrador definir las clases de almacenamiento que se tienen para ofrecer.
Con `Storage Class` puedes definir un `provisioner` como Google que puede aprovisionar automáticamente en Google Cloud y enlazarlo a un POD.
```yaml
# sc-definition.yaml

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
    name: google-storage
provisioner: kubernetes.io/gce-pd
parameters:
    type: [ pd-standard | pd-ssd ]
    replication-type: [ none | regional-pd ]
```

`Persistent Volume` se creará automáticamente
Entonces el vínculo del `storage class` se realiza con el `persistent volume claim`
```yaml
# pvc-definition.yaml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: myclaim
spec:
    accessModes:
        - ReadWriteOnce
    storageClassName: google-storage
    resources:
        requests:
            storage: 500Mi
```

## TROUBLESHOOTING

### Comandos Básicos de Troubleshooting
- `Kubectl get nodes` Estado de los Nodos
- `kubectl get pods`  Estado de los PODs
- `kubectl get pods -n kube-system`  Estado de los PODs del ControlPlane
- `service kube-apiserver status` Estado de los servicios del ControlPlane
- `service kube-controller-manager status` Estado de los servicios del ControlPlane
- `service kube-scheduler status` Estado de los servicios del ControlPlane
- `service kubelet status` Estado de los servicios del ControlPlane en el Nodo
- `service kube-proxy status` Estado de los servicios del ControlPlane en el Nodo
- `kubectl logs kube-apiserver-master -n kube-system` Revisar Logs del servicio
- `sudo journalctl -u kube-apiserver` Revisar Logs del servicio
- `sudo journalctl -u kubelet` Revisar kubelet logs
- `openssl x509 -in /var/lib/kubelet/worker-1.crt -text` Revisar los certificados

### Revisar Estado del Nodo
Desde un:
`Kubectl describe node worker-1`
Podremos ver un cuadro como este:

| Type            | Status     | Descripción                               | LastHeartBeatTime   |
| --------------- | ---------- | ----------------------------------------- | ------------------- |
| OutOfDisk       | True/False | Sin espacio en disco                      | Última comunicación |
| MemmoryPressure | True/False | Sin memoria RAM                           | Última comunicación |
| DiskPressure    | True/False | Capacidad del disco baja                  | Última comunicación |
| PIDPresure      | True/False | Muchos procesos corriendo                 | Última comunicación |
| Ready           | True/False | Saludable                                 | Última comunicación |
| N/A             | Unknown    | Cuando no logra comunicarse con el Master | Última comunicación |
### Rutas del Kubelet
Aquí encontraremos algunas rutas importantes a recordar que el `kubelet` utiliza:

- `/var/lib/kubelet/config.yaml` Ruta local de un `nodo` donde guarda la configuración del `kubelet service`. Dicho servicio toma las opciones de este archivo.
- `/etc/kubernetes/kubelet.conf` Archivo local de configuración de un `nodo`  usado por `kubelet` para conectarse con el `api server`

### CoreDNS y Kube-proxy
- `1. kubectl -n kube-system get deployment coredns -o yaml | sed 's/allowPrivilegeEscalation: false/allowPrivilegeEscalation: true/g' | kubectl apply -f -` Esto puede solucionar el Error de `CrashLoopBackOff`
- `netstat -plan | grep kube-proxy` Revisar si `kube-proxy` esta corriendo dentro del contenedor

## UPGRADE KUBEADM & NODES
Antes que nada debemos verificar el repositorio.
Esto aplica tanto para el `controlplane` como para los `nodos`:

```bash
vim /etc/apt/sources.list.d/kubernetes.list
```
Considerando que deseamos pasar a la versión `v1.32`. modificaremos la linea de la siguiente forma:
```bash
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /
```

### Determinar la Versión
Tanto para `controlplane` como para los `nodos` podemos listar todas las versiones disponibles una vez actualizado el repositorio:
```bash
sudo apt update
sudo apt-cache madison kubeadm
```

### Controlplane Upgrade
#### Kubeadm Upgrade
```bash
# Reemplaza la 'x' por la última versión mostrada en el comando anterior
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.32.x-*' && \
sudo apt-mark hold kubeadm
```

Verificamos que la descarga funcionó y tiene la versión correcta
```bash
kubeadm version
```

Verificamos el plan
```bash
sudo kubeadm upgrade plan
```

Elegimos la versión y corremos el comando
```bash
# Reemplaza la 'x' por la última versión mostrada arriba
sudo kubeadm upgrade apply v1.32.x
```

#### Kubelet y Kubectl Upgrade
```bash
# Reemplaza la 'x'
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet='1.32.x-*' kubectl='1.32.x-*' && \
sudo apt-mark hold kubelet kubectl
```

Ahora reiniciamos `kubelet`
```bash
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

### Nodes Upgrade
Considerando que ya revisamos el repositorio e hicimos los cambios antes mencionados, procedemos a:

#### Kubeadm Upgrade
```bash
# replace x in 1.32.x-* with the latest patch version
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.32.x-*' && \
sudo apt-mark hold kubeadm
```

En los nodos, esto actualiza la configuración del `kubelet` local:
```bash
sudo kubeadm upgrade node
```

#### Drena el Nodo
Colocamos al nodo en modo mantenimiento:
```bash
# Este comando se ejecuta en el controlplane
# Reemplaza el node-tro-drain con el nombre del nodo
kubectl drain <node-to-drain> --ignore-daemonsets
```

#### Kubelet Kubectl Upgrade
```bash
# replace x in 1.32.x-* with the latest patch version
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet='1.32.x-*' kubectl='1.32.x-*' && \
sudo apt-mark hold kubelet kubectl
```

Reiniciamos el `kubelet`
```bash
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

#### Activar el Nodo
Colocamos al nodo nuevamente en línea:
```bash
# execute this command on a control plane node
# replace <node-to-uncordon> with the name of your node
kubectl uncordon <node-to-uncordon>
```

### Referencia
Para más información seguir el enlace [oficial](https://v1-32.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)

## HELM
De forma simplificada se podría decir que es el Package manager de Kubernetes
### Instalación
Se puede seguir los pasos de la página [oficial](https://helm.sh/docs/intro/install/)
`sudo snap install helm --classic`

### Componentes
- Online Chart Repository: [artifacthub](https://artifacthub.io/)
- Charts
	- ![](Pasted%20image%2020250518212528.png)
Cuando un `chart` se aplica a un cluster, se genera un `release`

### Trabajando con HELM
- `helm search hub wordpress`: Buscamos WordPress en el `artifacthub`
- `helm search worpress`: Buscamos WordPress de forma local (Repositorio local)
- `helm repo add bitnami https://charts.bitnami.com/bitnami`: Añadimos el Publisher `bitmapi` a modo de repositorio local
- `helm install my-release bitnami/wordpress`: con el nombre `my-release` instalamos WordPress utilizando nuestro repositorio previamente añadido `bitmapi`
- `helm list`: Listar los release
- `helm repo list`: Listar los repositorios
- `helm repo update`: Actualizar los repositorios locales
- `helm upgrade my-release bitnami/wordpress`: Upgrade al WordPress en específico
- `helm install my-release bitnami/wordpress --version x.x.x`: Instalar una versión en específico
- `helm history my-release`: Ver el historial
- `helm rollback my-release 1`: Volver a una revisión anterior. En este caso la `1`. Aunque en realidad crea una revisión nueva que es igual a la `1`

### Personalizando Parámetros del Chart

#### Desde el archivo value.yaml
```yaml
# deployment.yaml
[...]
- name: WORDPRESS_BLOG_NAME
value: {{ .Values.wordpressBlogName | quote }}
```

```yaml
# value.yaml
wordpressBlogName: User's Blog!
```

#### De forma imperativa
`helm install --set wordpressBlogName="Helm Tutorials" my-release bitnami/worpress`

#### Usando un archivo value personalizado
`helm install --values custom-values.yaml my-release bitnami/worpress`

```yaml
# custom-values.yaml
worpressBlogName: Helm Tutorials
worpressEmail: john@example.com
```

## PUERTOS Y PROTOCOLOS

### ControlPlane

| Protocolo | Puerto    | Propósito               |
| --------- | --------- | ----------------------- |
| TCP       | 6443      | API server              |
| TCP       | 2379-2380 | ETCD server             |
| TCP       | 10250     | Kubelet API             |
| TCP       | 10259     | Kube-Scheduler          |
| TCP       | 10257     | Kube-controller-manager |
### Worker Nodes

| Protocolo | Puerto      | Propósito         |
| --------- | ----------- | ----------------- |
| TCP       | 10250       | Kubelet API       |
| TCP       | 10256       | Kube-Proxy        |
| TCP       | 30000-32767 | NodePort Services |




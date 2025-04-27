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

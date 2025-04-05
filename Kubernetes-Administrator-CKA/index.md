+++
date = '2025-03-23T20:32:16-05:00'
title = 'Kubernetes Administrator CKA'
+++

## PODs
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

## Deployments
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

## Services
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

## ConfigMap
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

## ReplicaSet
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
## Troubleshooting

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
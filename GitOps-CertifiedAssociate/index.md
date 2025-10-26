+++
date = '2025-10-16T18:45:18-05:00'
title = 'GitOps Certified Associate (CGOA)'
+++

## INTRODUCTION
Managing infrastructure and applications using Git as the single source of truth for declarative configuration, with automated reconciliation.

- Continuous: Like a thermostat of a room
- Declarative: Not imperative commands. It is what you want
- Desire State: Master plan, ultimate goal that `GitOps` aims for. Gives you consistency
- State Drift: Undesirable situation
- State Reconciliation: Detecting `state drift` and getting it back to the `desire state`
- GitOps Managed Software System: Git repository is the single source of truth.
- State Store: Git. Team can collaborate
- Feedback Loop: Observing the actual state.
- Rollback: Undo changes made to the configuration: `git revert xxxx` or using `Argo CD`

## GITOPS PRINCIPLES
`GitOps` can be considered an extension of `IaC` that uses `Git`as the version control system

- Declarative
- Versioned and Immutable
- Pulled automatically: Continuously pulls
- Continuously reconciled: Always matches the desired state

![](Pasted%20image%2020251016202410.png)

### ArgoCD Basics
It is a declarative, `GitOps`continuous delivery tool for `Kubernetes` resources defined in a Git repository.

It uses Git repositories as the source of truth for the desired state of app and the target deployment environments

**ArgoCD Concepts and Terminology:**
- Application
- Application source type
- Project
- Target state
- Live state
- Sync status
- Sync
- Sync operation status
- Refresh
- Health

## ARGOCD APP

Create an App
```bash
argocd app create color-app \
--repo https://github.com/sid/app-1.git \
--path team-a/color-app \
--dest-namespace color \
--dest-server https://kubernetes.default.svc
```

Automatically deploys de manifest

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: color-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/sid/app-1.git'
    targetRevision: HEAD
    path: team-a/color
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: color
  syncPolicy:
    automated:
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

- Source: Desired state
- Destination: Place where it needs to be deployed

### ArgoCD Demo

Official [Getting Started](https://argo-cd.readthedocs.io/en/stable/getting_started/)documentation.
And the git repository if you want an older version: [HERE](https://github.com/argoproj/argo-cd/releases/tag/v3.0.5)
`ArgoCD CLI` installation [HERE](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.0.5/manifests/install.yaml
```

To see the `ArgoCD` resources
```bash
kubectl -n argocd get all
```

The UI is on `service/argocd-server`
```bash
kubectl -n argocd edit srv argocd-server
```
And change `type: ClusterIP` to `type: NodePort`
So we are able to access the UI.

The initial password is on `secrets`
```bash
kubectl -n argocd get secrets
kubectl -n argocd get secrets argocd-initial-admin-secret -o json
# To filter
kubectl -n argocd get secrets argocd-initial-admin-secret -o json | jq .data.password -r | base64 -d
#Output: xxxxxxxxxxx
```

## IMPLEMENTING APPLICATION

### Create New Application in ArgoCD
![](Pasted%20image%2020251023195810.png)
- **Sync:** When `sync` we need to make sure the `Auto-Create Namespace` is enabled
- When we `sync` the code on the `repo` will be deployed into `Kubernetes`
```bash
kubectl get namespaces 
NAME                STATUS   AGE
argocd              Active   15m
default             Active   10h
highway-animation   Active   104s # <--- Created
kube-flannel        Active   10h
kube-node-lease     Active   10h
kube-public         Active   10h
kube-system         Active   10h
```

- If we manual change something with `kubectl` commands, the status on `argoCD` will be `OutOfSync`
- If we `sync` again. We will go back to what the repository says
- We also can have `auto-sync` (automatically reconcile whenever there is drift)
![](Pasted%20image%2020251023202247.png)

- If we change the `repo` and since we've applied `auto-sync` we will see the changes on the `kubernetes`

## GITOPS PATTERNS

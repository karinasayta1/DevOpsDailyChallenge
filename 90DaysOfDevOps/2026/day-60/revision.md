# Kubernetes Revision Guide (Before Day 60 Capstone)

> This revision is for someone who has completed the previous labs but wants to refresh everything from scratch.

---

# What is Kubernetes?

Kubernetes (K8s) is a container orchestration platform.

Docker creates containers.

Kubernetes manages containers.

It automatically

- Starts containers
- Stops failed containers
- Restarts crashed containers
- Scales applications
- Exposes applications to users
- Stores application data

Instead of manually managing containers, Kubernetes does it for us.

---

# Kubernetes Architecture

```
User
   │
kubectl
   │
API Server
   │
Scheduler
   │
Worker Node
   │
Pod
   │
Container
```

### Master Plane

Controls the cluster.

Contains

- API Server
- Scheduler
- Controller Manager
- etcd

### Worker Node

Runs your applications.

Contains

- kubelet
- kube-proxy
- Container Runtime

---

# kubectl

kubectl is the command line tool used to talk to Kubernetes.

Examples

```bash
kubectl get pods
kubectl get deployments
kubectl get svc
kubectl describe pod nginx
kubectl logs nginx
kubectl delete pod nginx
```

---

# Namespace (Day 52)

A Namespace is like a folder.

Instead of putting every application together, we organize them.

Example

```
default
kube-system
dev
production
capstone
```

Create namespace

```bash
kubectl create namespace capstone
```

Set default namespace

```bash
kubectl config set-context --current --namespace=capstone
```

View namespaces

```bash
kubectl get ns
```

---

# Pod

Pod is the smallest object in Kubernetes.

A Pod contains one or more containers.

Usually

```
1 Pod
   │
1 Container
```

Create Pod

```bash
kubectl run nginx --image=nginx
```

View Pods

```bash
kubectl get pods
```

Delete Pod

```bash
kubectl delete pod nginx
```

Problem

If Pod dies

➡ Everything is lost.

---

# Deployment (Day 52)

Deployment manages Pods.

Instead of creating Pods manually, create a Deployment.

Deployment automatically

- creates Pods
- recreates deleted Pods
- performs rolling updates
- scales Pods

Example

```
Deployment
      │
ReplicaSet
      │
Pods
```

Create Deployment

```bash
kubectl create deployment nginx --image=nginx
```

Scale Deployment

```bash
kubectl scale deployment nginx --replicas=3
```

---

# ReplicaSet

ReplicaSet ensures the desired number of Pods are always running.

Example

Desired Pods = 3

If one Pod crashes

ReplicaSet creates another automatically.

Usually you never create ReplicaSets directly.

Deployment creates them.

---

# Labels and Selectors

Labels identify resources.

Example

```yaml
labels:
  app: wordpress
```

Service finds Pods using labels.

Example

```
Pod

app=wordpress

↓

Service Selector

app=wordpress
```

If labels don't match

Service cannot find Pods.

---

# Service (Day 53)

Pods keep changing.

IP addresses change.

Service provides a permanent address.

Types

## ClusterIP

Default.

Only inside cluster.

```
Pod
   ↑
ClusterIP
```

Example

Backend database

---

## NodePort

Makes application available outside cluster.

Example

```
Browser

↓

NodeIP:30080

↓

Service

↓

Pod
```

NodePort range

```
30000-32767
```

---

## LoadBalancer

Used in cloud.

AWS

Azure

GCP

Not available in Kind unless extra software is installed.

---

# ConfigMap (Day 54)

Stores non-sensitive configuration.

Examples

```
Database Host

Database Name

Environment

Port
```

Example

```yaml
data:
  DB_HOST: mysql
  DB_NAME: wordpress
```

Mount using

```yaml
envFrom:
```

---

# Secret (Day 54)

Stores sensitive information.

Examples

- Password
- API Keys
- Tokens

Example

```yaml
stringData:
  MYSQL_PASSWORD: password123
```

Never hardcode passwords.

Pods read Secret using

```yaml
secretKeyRef
```

or

```yaml
envFrom
```

---

# Volumes

Containers are temporary.

If container dies

Files disappear.

Volumes keep data alive.

---

# Persistent Volume (PV)

Real storage.

Think of it as a hard disk.

---

# Persistent Volume Claim (PVC)

Application requests storage.

Example

```
Need

1Gi

ReadWriteOnce
```

PVC connects application to storage.

---

# StorageClass

Automatically creates storage.

Without StorageClass

PVC stays Pending.

Check

```bash
kubectl get storageclass
```

---

# StatefulSet (Day 56)

Deployment gives random Pod names.

StatefulSet gives fixed Pod names.

Example

```
mysql-0

mysql-1

mysql-2
```

Databases need stable identity.

Therefore

Use StatefulSet.

---

# Headless Service

Normal Service

```
Service

↓

Random Pod
```

Headless Service

```
Direct Pod access

mysql-0

mysql-1

mysql-2
```

Used with StatefulSet.

DNS

```
mysql-0.mysql.default.svc.cluster.local
```

---

# Resource Requests

Minimum resources guaranteed.

Example

```yaml
requests:
  cpu: 250m
  memory: 512Mi
```

Scheduler uses Requests.

---

# Resource Limits

Maximum allowed resources.

Example

```yaml
limits:
  cpu: 500m
  memory: 1Gi
```

If exceeded

CPU throttles.

Memory may kill Pod.

---

# Liveness Probe

Question

"Is application alive?"

If No

Restart Pod.

Example

```
App hangs

↓

Liveness fails

↓

Pod restarts
```

---

# Readiness Probe

Question

"Can users send traffic?"

If No

Service removes Pod.

Once healthy

Traffic starts again.

---

# HPA (Horizontal Pod Autoscaler)

Automatically changes number of Pods.

Example

```
CPU 20%

↓

2 Pods

CPU 80%

↓

6 Pods
```

Example

```yaml
minReplicas: 2

maxReplicas: 10

targetCPUUtilizationPercentage: 50
```

---

# Helm (Day 59)

Helm is Kubernetes package manager.

Like

```
apt

yum

dnf

npm
```

Instead of writing 20 YAML files

Helm installs everything.

Example

```bash
helm install wordpress bitnami/wordpress
```

Benefits

- Faster deployment
- Easy upgrades
- Easy rollback

---

# Self Healing

Delete Pod

```
kubectl delete pod nginx
```

Deployment immediately creates another.

This is called

Self-Healing.

---

# Scaling

Increase Pods

```bash
kubectl scale deployment nginx --replicas=5
```

Decrease Pods

```bash
kubectl scale deployment nginx --replicas=2
```

---

# Rolling Update

Update application without downtime.

Example

```
Old Pod

↓

New Pod

↓

Old removed

↓

Repeat
```

Rollback

```bash
kubectl rollout undo deployment nginx
```

---

# Port Forward

Access application locally.

```bash
kubectl port-forward svc/wordpress 8080:80
```

Browser

```
localhost:8080
```

---

# Important Commands

## Cluster

```bash
kubectl cluster-info
kubectl get nodes
```

## Namespace

```bash
kubectl get ns
```

## Pods

```bash
kubectl get pods
kubectl describe pod PODNAME
kubectl logs PODNAME
kubectl exec -it PODNAME -- bash
```

## Deployments

```bash
kubectl get deployments
kubectl scale deployment nginx --replicas=3
kubectl rollout status deployment nginx
kubectl rollout undo deployment nginx
```

## Services

```bash
kubectl get svc
```

## StatefulSet

```bash
kubectl get statefulsets
```

## ConfigMap

```bash
kubectl get configmaps
```

## Secret

```bash
kubectl get secrets
```

## PVC

```bash
kubectl get pvc
```

## StorageClass

```bash
kubectl get storageclass
```

## HPA

```bash
kubectl get hpa
```

## Everything

```bash
kubectl get all
```

---

# How Everything Connects

```
Namespace
│
├── Secret
│
├── ConfigMap
│
├── Headless Service
│      │
│      ▼
│   StatefulSet (MySQL)
│      │
│      ▼
│     PVC
│
├── Deployment (WordPress)
│      │
│      ▼
│   NodePort Service
│
└── HPA
```

---

# Which Resource Solves Which Problem?

| Problem | Kubernetes Resource |
|----------|---------------------|
| Organize applications | Namespace |
| Run containers | Pod |
| Keep Pods running | Deployment |
| Stable Pod identity | StatefulSet |
| Permanent networking | Service |
| Internal communication | ClusterIP |
| External access | NodePort |
| Store configuration | ConfigMap |
| Store passwords | Secret |
| Save data | PVC |
| Actual storage | PV |
| Automatic storage | StorageClass |
| Resource control | Requests & Limits |
| Restart unhealthy Pods | Liveness Probe |
| Send traffic only when ready | Readiness Probe |
| Automatic scaling | HPA |
| Easy installation | Helm |

---

# Final Goal (Day 60)

You will combine everything.

```
Namespace
      │
      ▼
Secret + ConfigMap
      │
      ▼
StatefulSet (MySQL)
      │
      ▼
PVC
      │
      ▼
Deployment (WordPress)
      │
      ▼
NodePort Service
      │
      ▼
Browser
      │
      ▼
HPA
```

Congratulations!

You now know all the Kubernetes concepts needed to complete the Day 60 Capstone.
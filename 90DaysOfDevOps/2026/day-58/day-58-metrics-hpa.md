# Day 58 – Metrics Server and Horizontal Pod Autoscaler (HPA)

## Objective

In this lab, you will install the Kubernetes Metrics Server, monitor resource usage using `kubectl top`, and configure a Horizontal Pod Autoscaler (HPA) to automatically scale your application based on CPU utilization. This demonstrates how Kubernetes handles changing workloads in production environments.

---

# Task 1 – Install the Metrics Server

## What you will learn

The **Metrics Server** collects CPU and memory usage from each node's kubelet and exposes it through the Kubernetes Metrics API. The Horizontal Pod Autoscaler depends on this data to determine when applications should scale. Without the Metrics Server, commands like `kubectl top` and HPA will not function.

## Check if Metrics Server is already installed

```bash
kubectl get pods -n kube-system | grep metrics-server
```

If nothing is returned, install it.

---

## For Minikube

```bash
minikube addons enable metrics-server
```

---

## For Kind / kubeadm / AWS EC2 Cluster

Install the official Metrics Server manifest.

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

---

## If using Kind or kubeadm

Edit the Metrics Server Deployment.

```bash
kubectl edit deployment metrics-server -n kube-system
```

Find:

```yaml
args:
```

Add the following argument:

```yaml
- --kubelet-insecure-tls
```

Save and exit.

> **Note:** This option is acceptable for local learning environments only. Never use it in production.

---

## Verify Installation

Wait about one minute.

Check Metrics Server Pod:

```bash
kubectl get pods -n kube-system
```

Check node metrics:

```bash
kubectl top nodes
```

Check Pod metrics:

```bash
kubectl top pods -A
```

Example output:

```text
NAME                     CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
ip-172-31-37-69          110m         11%    720Mi           35%
```

### Verification Answer

Record your node's CPU and memory usage from:

```bash
kubectl top nodes
```

---

# Task 2 – Explore kubectl top

## What you will learn

`kubectl top` displays **actual resource usage**, not configured requests or limits. The Metrics Server refreshes this data approximately every 15 seconds, allowing administrators to monitor live cluster resource consumption.

Run the following commands:

```bash
kubectl top nodes
```

```bash
kubectl top pods -A
```

Sort Pods by CPU usage:

```bash
kubectl top pods -A --sort-by=cpu
```

Sort Pods by memory:

```bash
kubectl top pods -A --sort-by=memory
```

### Verification Answer

Identify the Pod using the highest CPU.

Example:

```text
php-apache-6b7b8d76d5-xyz12
```

---

# Task 3 – Create a Deployment with CPU Requests

## What you will learn

The Horizontal Pod Autoscaler calculates CPU utilization as a percentage of the **CPU request** configured for each Pod. If CPU requests are not defined, HPA cannot determine utilization percentages and will not function correctly.

## Create `php-apache.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: php-apache
  template:
    metadata:
      labels:
        app: php-apache
    spec:
      containers:
      - name: php-apache
        image: registry.k8s.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 200m
```

Apply the Deployment:

```bash
kubectl apply -f php-apache.yaml
```

Expose it as a Service:

```bash
kubectl expose deployment php-apache --port=80
```

Verify:

```bash
kubectl get deployment
```

```bash
kubectl get svc
```

Check CPU usage:

```bash
kubectl top pod
```

### Verification Answer

Record the CPU usage displayed for the Pod.

---

# Task 4 – Create an HPA (Imperative)

## What you will learn

The Horizontal Pod Autoscaler continuously monitors CPU utilization. When average CPU usage exceeds the configured threshold, Kubernetes automatically increases the number of replicas. When utilization decreases, replicas are reduced after a stabilization period.

Create the HPA:

```bash
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
```

Verify:

```bash
kubectl get hpa
```

Describe it:

```bash
kubectl describe hpa php-apache
```

Initially you may see:

```text
TARGETS
<unknown>/50%
```

Wait about 30 seconds and check again.

Eventually:

```text
TARGETS
32%/50%
```

or

```text
78%/50%
```

### Verification Answer

Record the value shown under the **TARGETS** column.

---

# Task 5 – Generate Load and Watch Autoscaling

## What you will learn

HPA responds to increased CPU utilization by creating additional Pod replicas. As the number of Pods increases, incoming traffic is distributed across more containers, reducing average CPU utilization.

Create a load generator:

```bash
kubectl run load-generator \
--image=busybox:1.36 \
--restart=Never \
-- /bin/sh -c "while true; do wget -q -O- http://php-apache; done"
```

Watch HPA:

```bash
kubectl get hpa php-apache --watch
```

In another terminal:

```bash
kubectl get deployment php-apache --watch
```

or

```bash
kubectl get pods
```

Observe the replicas increasing.

Example:

```text
REPLICAS
1
2
4
5
```

Stop the load:

```bash
kubectl delete pod load-generator
```

The HPA will eventually scale the Deployment back down after approximately five minutes.

### Verification Answer

Record the highest number of replicas reached during the load test.

---

# Task 6 – Create an HPA from YAML (Declarative)

## What you will learn

Using YAML provides more control than the imperative command. The `autoscaling/v2` API supports multiple metrics and configurable scaling behaviors, allowing precise control over scale-up and scale-down operations.

Delete the previous HPA:

```bash
kubectl delete hpa php-apache
```

Create `hpa.yaml`

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache

  minReplicas: 1
  maxReplicas: 10

  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50

  behavior:
    scaleUp:
      stabilizationWindowSeconds: 0

    scaleDown:
      stabilizationWindowSeconds: 300
```

Apply:

```bash
kubectl apply -f hpa.yaml
```

Verify:

```bash
kubectl get hpa
```

Describe:

```bash
kubectl describe hpa php-apache
```

### Verification Answer

The **behavior** section controls:

* Scale-up speed
* Scale-down speed
* Stabilization windows
* Scaling policies

It prevents rapid fluctuations in the number of replicas.

---

# Task 7 – Clean Up

Delete the HPA:

```bash
kubectl delete hpa php-apache
```

Delete the Deployment:

```bash
kubectl delete deployment php-apache
```

Delete the Service:

```bash
kubectl delete service php-apache
```

Delete the load generator:

```bash
kubectl delete pod load-generator
```

Leave the Metrics Server installed.

---

# Key Concepts

## What is Metrics Server?

* Collects CPU and memory usage from kubelets.
* Provides metrics through the Kubernetes Metrics API.
* Required for `kubectl top`.
* Required for Horizontal Pod Autoscaler.

---

## How HPA Calculates Replicas

Formula:

```text
desiredReplicas =
ceil(currentReplicas × (currentCPUUtilization / targetCPUUtilization))
```

Example:

Current replicas = **2**

Current utilization = **90%**

Target = **50%**

```text
ceil(2 × (90/50))
=
ceil(3.6)
=
4 replicas
```

---

## autoscaling/v1 vs autoscaling/v2

| autoscaling/v1       | autoscaling/v2                         |
| -------------------- | -------------------------------------- |
| CPU metrics only     | CPU, Memory, External & Custom metrics |
| Simple configuration | Advanced configuration                 |
| No scaling behavior  | Supports scaling policies              |
| Limited options      | Production-ready                       |

---

## HPA Workflow

1. Metrics Server collects resource usage.
2. HPA queries Metrics API every 15 seconds.
3. CPU utilization is compared against the target.
4. If utilization is above target, replicas increase.
5. If utilization drops below target, replicas decrease after the stabilization window.

---



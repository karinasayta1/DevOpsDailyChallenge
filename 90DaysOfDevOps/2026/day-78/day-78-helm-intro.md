# Day 78 -- Introduction to Helm and Chart Basics

## Task 1: Understand Helm Concepts
Research and write notes on:

1. **What is Helm?**
   - A package manager for Kubernetes (like apt for Ubuntu or yum for RHEL)
   - Packages Kubernetes manifests into reusable, versioned units called **charts**
   - Supports templating -- one chart, many environments

2. **Core concepts:**
   - **Chart** -- a collection of files that describe a set of Kubernetes resources (Deployment + Service + ConfigMap + Secret = one chart)
   - **Release** -- a running instance of a chart in a cluster. You can install the same chart multiple times with different release names
   - **Repository** -- a place where charts are stored and shared (like DockerHub for images)
   - **Values** -- configuration that customizes a chart for each deployment (replicas, image tag, resource limits)

3. **Why Helm over raw manifests?**
   - Look at the AI-BankApp's `k8s/` directory -- 12 separate YAML files. To change the image tag, you edit `bankapp-deployment.yml`. To switch environments, you manually update ConfigMaps and Secrets. Helm solves this:
   - Templating: one chart serves dev, staging, and prod with different values
   - Versioning: charts have version numbers, you can rollback to previous versions
   - Dependencies: a chart can depend on other charts (your app chart depends on a MySQL chart)
   - Community: thousands of pre-built charts for common software (MySQL, Redis, Prometheus, ArgoCD)

---

## Task 2: Install Helm and Explore the AI-BankApp
You need a running Kubernetes cluster. Use any of these:
- **Kind** (recommended for this block): Use the AI-BankApp's Kind config
- **Minikube**: `minikube start`
- **Docker Desktop Kubernetes**: enable in settings

**Set up a Kind cluster using the AI-BankApp's config:**
```bash
git clone -b feat/gitops https://github.com/TrainWithShubham/AI-BankApp-DevOps.git
cd AI-BankApp-DevOps

kind create cluster --config setup-k8s/kind-config.yml
```

This creates a cluster with 1 control plane and 2 worker nodes.

**Install Helm:**
```bash
# macOS
brew install helm

# Linux (script)
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify
helm version
```

   ![snapshot](images/2-a.png)

Confirm Helm can talk to your cluster:
```bash
kubectl cluster-info
helm list
```

   ![snapshot](images/2-b.png)

**Explore the raw manifests you will eventually replace with Helm:**
```bash
ls k8s/
```

   ![snapshot](images/2-c.png)

```
bankapp-deployment.yml   configmap.yml   gateway.yml   mysql-deployment.yml
namespace.yml   ollama-deployment.yml   pv.yml   pvc.yml   secrets.yml
service.yml   hpa.yml   cert-manager.yml
```

12 files -- Deployments, Services, ConfigMaps, Secrets, PVCs, HPA, and more. All hardcoded values. On Day 79, you will convert these into a Helm chart.

---

## Task 3: Deploy MySQL Using a Helm Chart
The AI-BankApp needs MySQL. Instead of applying raw YAML like `k8s/mysql-deployment.yml`, deploy it with Helm.

Add the stable chart repository:
```bash
helm repo add stable https://charts.helm.sh/stable
helm repo update
```

Search for MySQL:
```bash
helm search repo stable/mysql
```

**Deploy MySQL with the same config the AI-BankApp expects:**
```bash
helm install bankapp-mysql stable/mysql \
  --set mysqlRootPassword=Test@123 \
  --set mysqlDatabase=bankappdb \
  --set resources.requests.memory=256Mi \
  --set resources.requests.cpu=250m \
  --set resources.limits.memory=512Mi \
  --set resources.limits.cpu=500m \
  --set persistence.size=5Gi
```

   ![snapshot](images/3-a.png)

Compare this single command to the raw manifest approach which needs `mysql-deployment.yml` + `secrets.yml` + `pvc.yml` + `pv.yml` + `service.yml`. Helm handles all of it.

Check what was created:
```bash
helm list
kubectl get all -l app=bankapp-mysql
kubectl get pvc -l app=bankapp-mysql
kubectl get secret -l app=bankapp-mysql
```

   ![snapshot](images/3-b.png)

Verify MySQL is running:
```bash
kubectl exec -it bankapp-mysql-0 -- mysql -uroot -pTest@123 -e "SHOW DATABASES;"
```

   ![snapshot](images/3-c.png)

You should see `bankappdb` in the output.

---

## Task 4: Customize a Deployment with Values Files
`--set` works for quick overrides, but real projects use values files.

Create `mysql-values.yaml`:
```yaml
mysqlRootPassword: Test@123
mysqlDatabase: bankappdb
resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi
persistence:
  size: 5Gi
  storageClass: ""
metrics:
  enabled: true
  serviceMonitor:
    enabled: false
```

Deploy with the values file:
```bash
helm install bankapp-mysql-v2 bitnami/mysql -f mysql-values.yaml
```

   ![snapshot](images/4-a.png)

**To see all configurable values for a chart:**
```bash
helm show values bitnami/mysql | head -80
```

   ![snapshot](images/4-b.png)

This is your reference for every knob you can turn. Notice how the chart supports metrics, replication, custom init scripts, and dozens more options -- all through values.

**Clean up the second release:**
```bash
helm uninstall bankapp-mysql-v2
```

   ![snapshot](images/4-c.png)

---

## Task 5: Manage Releases -- Upgrade, Rollback, Uninstall
Helm tracks every change as a **revision**. This lets you upgrade and rollback safely.

**Upgrade MySQL to enable metrics:**
```bash
helm upgrade bankapp-mysql stable/mysql   --set mysqlRootPassword=Test@123   --set mysqlDatabase=bankappdb   --set metrics.enabled=true  --reuse-values
```

   ![snapshot](images/5-a.png)

Check the revision history:
```bash
helm history bankapp-mysql
```

   ![snapshot](images/5-b.png)

You should see revision 1 (original) and revision 2 (metrics enabled).

**Rollback to the previous version:**
```bash
helm rollback bankapp-mysql 1
```

   ![snapshot](images/5-c.png)

Check history again:
```bash
helm history bankapp-mysql
```

   ![snapshot](images/5-d.png)

Revision 3 appears -- a rollback to revision 1.

**Compare this to raw manifests:** With `kubectl apply`, there is no built-in rollback. You would have to `git revert` or manually re-apply old YAML. Helm gives you `helm rollback` out of the box.

---

## Task 6: Explore a Chart's Structure
Before building your own chart for the AI-BankApp tomorrow, understand what is inside a Helm chart.

Pull the MySQL chart locally:
```bash
helm pull bitnami/mysql --untar
ls mysql/
```

You will see:
```
mysql/
  Chart.yaml              # Chart metadata (name, version, description)
  values.yaml             # Default configuration values
  charts/                 # Subchart dependencies
  templates/              # Kubernetes manifest templates
    primary/
      statefulset.yaml    # StatefulSet template with Go template syntax
      svc.yaml            # Service template
    _helpers.tpl          # Reusable template helpers
    NOTES.txt             # Post-install message shown to the user
    secrets.yaml          # Secret template
```

Open `templates/primary/statefulset.yaml` and look for Go template syntax:
```yaml
replicas: {{ .Values.primary.replicaCount }}
image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
```

`{{ .Values.primary.replicaCount }}` pulls from `values.yaml`. When you pass `--set primary.replicaCount=3`, it overrides this value.

Open `Chart.yaml`:
```yaml
apiVersion: v2
name: mysql
description: A Helm chart for MySQL
version: 12.2.1      # Chart version (chart structure changes)
appVersion: "8.0.40"  # Version of MySQL inside the chart
```

**Now compare the Helm chart approach to the AI-BankApp's raw manifests:**

| Aspect | AI-BankApp `k8s/mysql-deployment.yml` | Bitnami MySQL Helm Chart |
|--------|---------------------------------------|--------------------------|
| Secrets | Hardcoded base64 in `secrets.yml` | Generated and managed by Helm |
| Storage | Manual StorageClass + PVC files | Configured via `persistence.size` value |
| Replicas | Hardcoded in YAML | `primary.replicaCount` value |
| Metrics | Not included | `metrics.enabled: true` |
| Rollback | Manual | `helm rollback` |

**Document:** What is the difference between `version` and `appVersion` in Chart.yaml?
   - `version` : Chart version number. It is used by Helm to track changes to the chart itself (templates, values, structure).
   - `appVersion` : Version of appllication.(e.g., MySQL image version).

Clean up:
```bash
helm uninstall bankapp-mysql
rm -rf mysql/
```

---


- Your `mysql-values.yaml` and explanation of each field

```yml
mysqlRootPassword: Test@123    #Root user password for MySQL
mysqlDatabase: bankappdb       #Name of the initial database created at startup
resources:                     #Pod resource requests and limits
  limits:                      #Container cannot exceed these
    cpu: 500m
    memory: 512Mi
  requests:                    #Guaranteed minimum resources
    cpu: 250m
    memory: 256Mi
persistence:                   #PersistentVolumeClaim settings
  size: 5Gi                    #Requested storage size
  storageClass: ""             #Default storage class to use
metrics:                       #Separate metrics deployment
  enabled: true                #Deploys bankapp-mysql-metrics Deployment
  serviceMonitor:              #Optional integration with Prometheus Operator
    enabled: false             #Disabled by default
```

- Why the AI-BankApp's 12 raw YAML files would benefit from being a Helm chart
   - Problem
      - Manual `kubectl apply -f` each file
      - No rollback (kubectl can't undo)
      - Secret/password updates require editing files
      - HArdcoded values or files for each config
      - Difficult to share
      - To switch environments, you manually update ConfigMaps and Secrets.
   - Why helm
      - Apply all configs in one command `helm install`
      - Rollback to any version
      - Secrets/password Generated and managed by Helm
      - Values can be passed dynamically
      - Packaged and easily reusable/sharable
      - Templating: one chart serves dev, staging, and prod with different values

---
   
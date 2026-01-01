## NestJS GitOps Deployment with Helm & Argo CD
This project demonstrates a production-style GitOps workflow to deploy a NestJS application on Kubernetes using Helm and Argo CD.

### Repositories
Application (CI builds image)
👉 https://github.com/hannu1992/nestjs-app

GitOps / Deployment (this repo)
👉 https://github.com/hannu1992/nestjs-app-helm-gitops-k8s

### Tools Used
- Git & GitHub
- GitHub Actions (CI)
- Docker
- Kubernetes (Minikube)
- Helm
- Argo CD
- NestJS

### How to Run This Project (Actual Steps)
#### Start Kubernetes (Minikube)
```
- minikube start
- kubectl get nodes
```

#### Install Argo CD
```
kubectl create namespace argocd
kubectl apply -n argocd -f \
https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Wait until all pods are running:
```
kubectl get pods -n argocd
```

### Deploy via GitOps
From this repository root:
```
kubectl apply -f argocd-application.yaml
```
Verify:
```
kubectl get applications -n argocd
```

### Deploy a New Application Version (Real GitOps Action)
Edit:
```
helm/nestjs-app/values.yaml
```
Update the Docker image tag (must exist in Docker Hub):
```
image:
  repository: hannumannamdev1992/nestjs-app
  tag: "3fa4c1b"
```
Commit & push:
```
git add helm/nestjs-app/values.yaml
git commit -m "deploy new image version"
git push
```

### Argo CD automatically syncs the cluster.

### Verify Deployment
```
kubectl get pods -n nestjs
```
Expected:
- Running

### Access the Application
```
kubectl port-forward svc/nestjs-app -n nestjs 3000:80
```

Test:
```
curl http://localhost:3000/health
```

Expected:

{ "status": "ok" }

#### What Happens Automatically
- CI builds & pushes Docker image
- Git change updates values.yaml
- Argo CD detects the change
- Helm renders Kubernetes manifests
- Cluster state is reconciled
- Pods restart with new image

No manual deployment.
No kubectl in CI.
No SSH.

### Health Checks
Application exposes:

```
GET /health
```

Used by Kubernetes:
- livenessProbe
- readinessProbe

Ensures traffic is routed only to healthy pods.

### How to Test GitOps Behavior
- Set a wrong image tag in values.yaml
- Push change
- Pods go ImagePullBackOff
- Fix tag
- Push again
- Argo CD auto-heals the deployment
- This validates GitOps in practice.

### Rollback Strategy
Rollback is done via Git:
```
git revert <commit>
git push
```

Argo CD automatically restores the previous working version.

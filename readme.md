## Purpose of this Repository
Store Helm charts for Kubernetes deployment
Act as the single source of truth for cluster state
Be continuously reconciled by Argo CD

Enable safe, auditable, Git-based deployments

### 🧱 Architecture Overview
Application Repo (nestjs-app)
  └─ CI (GitHub Actions)
      ├─ test & build
      ├─ build Docker image
      └─ push image to registry

GitOps Repo (this repo)
  ├─ Helm chart
  ├─ image tag in values.yaml
  └─ Argo CD Application

Argo CD
  └─ Watches GitOps repo
  └─ Renders Helm chart
  └─ Syncs state to Kubernetes

### 📂 Repository Structure
nestjs-app-helm-gitops-k8s/
├── argocd-application.yaml        # Argo CD Application definition
├── helm/
│   └── nestjs-app/
│       ├── Chart.yaml             # Helm chart metadata
│       ├── values.yaml            # Configurable values (image tag, replicas, resources)
│       └── templates/
│           ├── deployment.yaml    # Kubernetes Deployment template
│           └── service.yaml       # Kubernetes Service template
└── README.md

### ⚙️ Helm Chart Details
Chart.yaml

Chart name, version, and metadata
Used by Helm for packaging and versioning
values.yaml (most important file)
This is where deploy-time configuration lives.

image:
  repository: hannumannamdev1992/nestjs-app
  tag: "REPLACE_ME"


🔁 Updating image.tag triggers a new deployment via Argo CD.

Templates
deployment.yaml
Uses Helm templating
Configures:
replicas
resources
liveness & readiness probes

service.yaml

### Exposes the application inside the cluster

## 🔄 GitOps Workflow

Developer pushes code to application repo

CI builds & pushes Docker image

Image tag is updated in values.yaml (manually or via automation)

Commit is pushed to this GitOps repo

Argo CD detects change

Argo CD renders Helm chart

Kubernetes state is reconciled automatically

🚦 Argo CD Application

argocd-application.yaml tells Argo CD:

Which repo to watch

Which Helm chart to deploy

Which namespace to deploy into

To enable auto-sync, prune, and self-heal

syncPolicy:
  automated:
    prune: true
    selfHeal: true

🩺 Health Checks

The application exposes:

GET /health


Used by:

Kubernetes livenessProbe

Kubernetes readinessProbe

This ensures:

Traffic is sent only to healthy pods

Containers are restarted if unhealthy

🚀 Deployment Requirements

Kubernetes cluster (Minikube / EKS / AKS / GKE)

Argo CD installed

Docker image available in registry

Correct image tag set in values.yaml

🔐 Security & Best Practices

No secrets stored in this repo

No CI pipelines in this repo

No kubectl usage in CI

All changes are auditable via Git history

🎯 Key Principles Followed

CI ≠ CD

Git is the source of truth

Declarative over imperative

Infrastructure changes via pull requests

Argo CD continuously reconciles state

📝 Summary (Interview-ready)

This repository implements a GitOps-based Kubernetes deployment using Helm and Argo CD.
Application builds are handled by CI, while this repo declaratively defines how the app runs in the cluster.
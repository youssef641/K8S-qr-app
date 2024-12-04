# QR Code App Deployment with Kubernetes

This project demonstrates deploying a QR code generation app on a Kubernetes cluster. The application includes two services: a **Backend API** for generating QR codes and a **Frontend** built with Next.js. This guide walks through the steps to build, deploy, and access the app in a Kubernetes environment.

---

## Features

- **Backend API**: Provides an API endpoint for generating QR codes.
- **Frontend**: Built with Next.js, it provides a UI to interact with the API and display the generated QR codes.
- **Dockerized**: Both backend and frontend services are containerized using Docker for ease of deployment.
- **Kubernetes**: The application is deployed using Kubernetes for scalability and management.
- **Persistent Storage**: QR code images are stored using a persistent volume in Kubernetes.

---

## Requirements

- **Kubernetes** (kubeadm setup or K3s)
- **Docker** (for building and pushing container images)
- **kubectl** (for interacting with Kubernetes)
- **Minikube** or **Kind** (for local Kubernetes clusters) or a cloud-based Kubernetes cluster

---

## Directory Structure

```plaintext
.
├── api
│   ├── Dockerfile                # Backend API Dockerfile
│   ├── k8s                       # Kubernetes manifests for the API
│   │   ├── deployment.yaml       # API deployment configuration
│   │   ├── service.yaml          # API service configuration
│   │   └── pv.yaml               # Persistent volume configuration
├── front-end-nextjs
│   ├── Dockerfile                # Frontend Dockerfile
│   ├── k8s                       # Kubernetes manifests for the frontend
│   │   ├── deployment.yaml       # Frontend deployment configuration
│   │   └── service.yaml          # Frontend service configuration
├── k8s                           # Kubernetes manifests
│   └── namespace.yaml            # Namespace configuration for the app
└── deploy.sh                     # Deployment script for building images and deploying to Kubernetes

```
### How It Works
## 1. Backend API
 - The API listens for requests to generate QR codes.
 - It uses a persistent volume to store the generated QR code images.
 - The API is exposed as a Kubernetes service and can be scaled for high availability.
## 2. Frontend
 - The frontend is a simple UI built with Next.js.
 - It interacts with the backend API to generate and display QR codes.
 - The frontend is exposed as a Kubernetes service.
---

### Configuration
  To customize the application, you can modify the following:

   - Backend API: Update API logic in api/Dockerfile and api/k8s/deployment.yaml.
   - Frontend: Modify the frontend application in front-end-nextjs/Dockerfile.
   ---
### Logs and Troubleshooting

 - Check pod status: kubectl get pods -n my-app-namespace
 - View logs: kubectl logs <pod-name> -n my-app-namespace
 - Restart Kubernetes resources: kubectl rollout restart deployment <deployment-name> -n my-app-namespace
---
### Common Issues
 - Image pull errors: Ensure that Docker images are pushed to the correct registry and accessible from Kubernetes.
 - Service not reachable: Ensure the Kubernetes services are correctly exposed (use kubectl port-forward if needed).
---
### Improvements to Consider
 - Add horizontal pod autoscaling for the API based on CPU or memory usage.
 - Use an ingress controller for better handling of frontend and backend services.
 - Implement robust error handling for QR code generation failures.


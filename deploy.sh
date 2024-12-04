#!/bin/bash

# Define image names and namespace
API_IMAGE="api:latest"
FRONT_IMAGE="frontend:latest"
NAMESPACE="my-app-namespace"

# Build Docker images for API and Frontend
echo "Building API Docker image..."
docker build -t $API_IMAGE ./api

echo "Building Frontend Docker image..."
docker build -t $FRONT_IMAGE ./front-end-nextjs/

# Check Kubernetes context (k3s, Minikube, or Kind)
if kubectl config current-context | grep -q "k3s"; then
  echo "Using k3s, pushing Docker images to local registry..."

  # For k3s, if you're using a local registry, push the image to the local registry
  # If you're using an external registry, you can change the image tags accordingly
  K3S_CLUSTER_IP=$(kubectl cluster-info | grep -o 'https://[0-9.]*' | head -n 1 | sed 's/https:\/\///')
  LOCAL_REGISTRY_PORT=5000  # Adjust this if using a different registry port
  
  # Tag and push images to the local k3s registry
  docker tag $API_IMAGE $K3S_CLUSTER_IP:$LOCAL_REGISTRY_PORT/$API_IMAGE
  docker tag $FRONT_IMAGE $K3S_CLUSTER_IP:$LOCAL_REGISTRY_PORT/$FRONT_IMAGE
  
  # Push images to k3s registry
  docker push $K3S_CLUSTER_IP:$LOCAL_REGISTRY_PORT/$API_IMAGE
  docker push $K3S_CLUSTER_IP:$LOCAL_REGISTRY_PORT/$FRONT_IMAGE

elif kubectl config current-context | grep -q "minikube"; then
  echo "Loading API image into Minikube..."
  minikube image load $API_IMAGE
  echo "Loading Frontend image into Minikube..."
  minikube image load $FRONT_IMAGE

elif kubectl config current-context | grep -q "kind"; then
  echo "Loading API image into Kind..."
  kind load docker-image $API_IMAGE
  echo "Loading Frontend image into Kind..."
  kind load docker-image $FRONT_IMAGE

else
  echo "Unknown Kubernetes context, skipping image loading."
fi

# Apply Kubernetes resources
echo "Deploying to Kubernetes..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f api/k8s/pv.yaml
kubectl apply -f api/k8s/deployment.yaml
kubectl apply -f api/k8s/service.yaml
kubectl apply -f front-end-nextjs/k8s/deployment.yaml  # Assuming you have a deployment.yaml for the frontend
kubectl apply -f front-end-nextjs/k8s/service.yaml    # Assuming you have a service.yaml for the frontend

echo "Deployment complete."

#!/bin/bash

# Usage: ./update_image.sh
# Example: ./update_image.sh myrepo/myapp v1.0
# This script commits changes to Git,
# builds & pushes Docker image, then updates YAML & applies deployment.

DEPLOY_FILE="python-deployment.yml"

# -------------------------------
# 1. Get inputs
# -------------------------------
read -p "👉 Enter Docker image name (e.g. myrepo/myapp) [default: myrepo/myapp]: " IMAGE_NAME
read -p "👉 Enter tag (e.g. v1.0) [default: latest]: " IMAGE_TAG

IMAGE_NAME=${IMAGE_NAME:-myrepo/myapp}
IMAGE_TAG=${IMAGE_TAG:-latest}
FULL_IMAGE="$IMAGE_NAME:$IMAGE_TAG"

# -------------------------------
# 2. Git operations (commit & push first)
# -------------------------------
git status
git add .
git commit -m "Preparing for new image build: $FULL_IMAGE"
git pull --rebase
git push
echo "✅ Changes committed & pushed to Git repo"

# -------------------------------
# 3. Docker operations
# -------------------------------
echo "🐳 Building Docker image..."
docker build -t "$FULL_IMAGE" .

echo "🐳 Tagging Docker image..."
docker tag "$FULL_IMAGE" "$FULL_IMAGE"

echo "🐳 Pushing Docker image to Docker Hub..."
docker push "$FULL_IMAGE"

echo "🐳 Pulling image back from Docker Hub to verify..."
docker pull "$FULL_IMAGE"

# -------------------------------
# 4. Update YAML & apply deployment
# -------------------------------
sed -i "s|\(image:\s*\).*|\1$FULL_IMAGE|g" "$DEPLOY_FILE"
echo "✅ Updated $DEPLOY_FILE with image: $FULL_IMAGE"

echo "🚀 Applying Kubernetes deployment..."
kubectl apply -f "$DEPLOY_FILE"

# Optional: restart pods to ensure rollout
kubectl rollout restart deployment python-deployment

echo "✅ Deployment updated and restarted with image: $FULL_IMAGE"


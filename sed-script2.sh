#!/bin/bash

# Usage: ./update_image.sh
# This script will ask for a Docker image with tag to replace in deployment.yaml

DEPLOY_FILE="python-deployment.yml"

# Ask the user for input
read -p "👉 Please enter the Docker image with tag (default: nginx:latest): " NEW_IMAGE

# If user just presses Enter, use default
NEW_IMAGE=${NEW_IMAGE:-nginx:latest}

# Replace the full image line
sed -i "s|\(image:\s*\).*|\1$NEW_IMAGE|g" "$DEPLOY_FILE"

echo "✅ Updated $DEPLOY_FILE with image: $NEW_IMAGE"

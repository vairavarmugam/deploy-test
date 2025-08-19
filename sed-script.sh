#!/bin/bash

# Usage: ./update_image.sh nginx:v1
# If no argument is given, default will be 'nginx:latest'

DEPLOY_FILE="python-deployment.yml"
NEW_IMAGE=${1:-nginx:latest}

# Replace the full image line
sed -i "s|\(image:\s*\).*|\1$NEW_IMAGE|g" "$DEPLOY_FILE"

echo "✅ Updated $DEPLOY_FILE with image: $NEW_IMAGE"

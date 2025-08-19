#!/bin/bash

image_name=$1
tag=$2
yaml_file="pyhton-deployment.yml"


echo "Pulling image from Docker Hub!!!"
docker pull "$image_name:$tag"

echo "Updating image in YAML file..."
# Escape slashes in image_name for sed
escaped_image_name=$(echo "$image_name" | sed 's/\//\\\//g')
# Replace the line starting with 'image:' to the new image and tag
sed -i "s/^ *image:.*$/  image: $escaped_image_name:$tag/" "$yaml_file"

echo "Applying Kubernetes YAML..."
kubectl apply -f "$yaml_file"

echo "Pods are creating!!"


#!/bin/bash

image_name=$1
tag=$2
yaml_file="pyhton-deployment.yml"


echo "Pulling image from Docker Hub!!!"
docker pull "$image_name:$tag"
echo "fixing  $image_name:$tag in your $yaml_file"
sed -i 's/alpine/$image_name:$tag/g' $yaml_file


echo "pods are creating!!"
kubectl apply -f "$yaml_file"


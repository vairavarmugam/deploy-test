import docker
import yaml
import argparse

def pull_docker_image(image_name: str, tag: str = "latest"):
    client = docker.from_env()
    full_image = f"{image_name}:{tag}"
    print(f"Pulling image {full_image} from Docker Hub...")
    try:
        image = client.images.pull(image_name, tag=tag)
        print(f"Successfully pulled {full_image}")
    except docker.errors.APIError as e:
        print(f"Failed to pull image: {e}")

def update_image_tag_in_yaml(yaml_path: str, image_name: str, new_tag: str):
    with open(yaml_path) as f:
        docs = list(yaml.safe_load_all(f))

    changed = False
    for doc in docs:
        if doc.get('kind') == 'Deployment':
            containers = doc['spec']['template']['spec']['containers']
            for container in containers:
                image = container.get('image', '')
                if image.startswith(image_name.split(':')[0]):  # match base image name without tag
                    container['image'] = f"{image_name.split(':')[0]}:{new_tag}"
                    changed = True

    if changed:
        with open(yaml_path, 'w') as f:
            yaml.dump_all(docs, f)
        print(f"Updated image tag to {new_tag} in {yaml_path}")
    else:
        print(f"No matching image found in {yaml_path} to update.")

def main():
    parser = argparse.ArgumentParser(description="Pull Docker image and update tag in k8s YAML")
    parser.add_argument("--image", required=True, help="Docker image name (e.g., alpine or myrepo/myimage)")
    parser.add_argument("--tag", default="latest", help="Image tag to pull and set (default: latest)")
    parser.add_argument("--yaml", required=True, help="Path to Kubernetes deployment YAML file")

    args = parser.parse_args()

    pull_docker_image(args.image, args.tag)
    update_image_tag_in_yaml(args.yaml, args.image, args.tag)

if __name__ == "__main__":
    main()


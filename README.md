# kubectl

Custom kubectl Docker image based on Alpine Linux with essential Kubernetes tools.

## Features

This Docker image includes:
- **Base OS**: Alpine Linux 3.19
- **Shell**: bash with bash-completion
- **Utilities**: curl, openssl, wget, git, jq, yq
- **Container Tools**: docker-cli
- **Kubernetes Tools**: kubectl, helm

## Usage

### Pull from Docker Hub

```bash
docker pull nhahv/kubectl:latest
```

### Run the container

```bash
docker run -it nhahv/kubectl:latest
```

### Mount Kubernetes config

```bash
docker run -it -v ~/.kube:/root/.kube nhahv/kubectl:latest
```

### Available Tags

- `latest` - Built from the main branch
- `v*` - Semantic version tags (e.g., v1.0.0)
- `<branch>-<sha>` - Branch-specific builds with commit SHA

## Automated Builds

This image is automatically built and pushed to Docker Hub via GitHub Actions when:
- Code is pushed to the `main` or `master` branch
- A new version tag (v*) is created
- Manual workflow dispatch is triggered

### Setting Up Docker Hub Credentials

To enable automatic builds, configure the following secrets in your GitHub repository:
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Your Docker Hub access token

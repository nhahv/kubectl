FROM alpine:3.19

# Update apk repositories and install base packages
RUN apk update && apk add --no-cache \
    bash \
    bash-completion \
    curl \
    openssl \
    wget \
    git \
    jq \
    ca-certificates

# Install yq (with multi-arch support)
RUN ARCH=$(uname -m) && \
    case "$ARCH" in \
        x86_64) YQ_ARCH="amd64" ;; \
        aarch64) YQ_ARCH="arm64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    wget -qO /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}" && \
    chmod +x /usr/local/bin/yq

# Install docker-cli
RUN apk add --no-cache docker-cli

# Install kubectl (with multi-arch support)
RUN ARCH=$(uname -m) && \
    case "$ARCH" in \
        x86_64) KUBECTL_ARCH="amd64" ;; \
        aarch64) KUBECTL_ARCH="arm64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# Install helm (using specific version for security)
RUN HELM_VERSION="v3.14.0" && \
    ARCH=$(uname -m) && \
    case "$ARCH" in \
        x86_64) HELM_ARCH="amd64" ;; \
        aarch64) HELM_ARCH="arm64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    wget -qO- "https://get.helm.sh/helm-${HELM_VERSION}-linux-${HELM_ARCH}.tar.gz" | tar xz && \
    mv linux-${HELM_ARCH}/helm /usr/local/bin/helm && \
    rm -rf linux-${HELM_ARCH}

# Set bash as default shell
SHELL ["/bin/bash", "-c"]
CMD ["/bin/bash"]

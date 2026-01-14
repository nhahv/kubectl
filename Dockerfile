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

# Install yq
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq

# Install docker-cli
RUN apk add --no-cache docker-cli

# Install kubectl
RUN KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# Install helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Set bash as default shell
SHELL ["/bin/bash", "-c"]
CMD ["/bin/bash"]

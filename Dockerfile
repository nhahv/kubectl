FROM alpine:3

RUN apk add --update  --no-cache ca-certificates bash bash-completion curl openssh
RUN apk add --no-cache wget git jq yq openssl bash docker-cli  kustomize envsubst
# iputils(ping), iproute2(ip, ss), bind-tools(dig), traceroute, netcat-openbsd(nc), tcpdump
RUN apk add --no-cache \
    iputils \  
    iproute2 \
    bind-tools \
    traceroute \
    netcat-openbsd \
    tcpdump \
    busybox-extras
RUN  wget -q https://storage.googleapis.com/kubernetes-release/release/$(wget -q -O- https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash

RUN curl -sSL \
    https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz \
    | tar -xz -C /usr/local/bin \
    && chmod +x /usr/local/bin/kustomize



WORKDIR /root
# RUN mkdir -p /etc/bash_completion.d/
# RUN kubectl completion bash > /etc/bash_completion.d/kubectl | true

RUN echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc
RUN echo "source <(kubectl completion bash)" >> ~/.bashrc
RUN echo "source <(helm completion bash)" >> ~/.bashrc
RUN echo "source <(kustomize completion bash)" >> ~/.bashrc

# COPY ./config /root/.kube/config

# ENTRYPOINT [ "docker" ]
# ENTRYPOINT ["kubectl"]

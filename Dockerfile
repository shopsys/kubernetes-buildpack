FROM docker:24.0.6

ENV KUBECTL_VERSION="1.31.1"
ENV YQ_VERSION="2.1.1"
ENV KUSTOMIZE_VERSION="3.8.5"

WORKDIR /tmp

# Install dependencies
RUN apk add --update --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    gnupg \
    libc6-compat \
    openssh-client \
    openssl \
    openvpn \
    python3 \
    py3-pip \
    py-crcmod \
    tar \
    unzip \
    wget \
    && rm -rf /var/cache/apk/*

# Install Kubectl
RUN curl --location https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl --output /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --client -o yaml

# Install yq
RUN curl --location https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 --output /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

# Install Kustomize
RUN curl --location https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz --output kustomize.tar.gz && \
    tar xzf kustomize.tar.gz && \
    mv kustomize /usr/local/bin/kustomize && \
    chmod +x /usr/local/bin/kustomize && \
    kustomize version

RUN mkdir -p /root/.kube/

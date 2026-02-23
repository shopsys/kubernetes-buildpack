FROM docker:29.2.1-cli

WORKDIR /tmp

# Install dependencies
RUN apk add --update --no-cache \
    bash \
    ca-certificates \
    curl \
    openssl \
    python3 \
    py3-pip \
    kubectl \
    yq-go \
    kustomize \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /root/.kube/

ENV PIP_BREAK_SYSTEM_PACKAGES=1

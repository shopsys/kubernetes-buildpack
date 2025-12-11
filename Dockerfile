FROM docker:29.1.2-alpine3.23

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
    python3 \
    py3-pip \
    py-crcmod \
    tar \
    unzip \
    wget \
    kubectl \
    yq-go \
    kustomize \
    && rm -rf /var/cache/apk/*


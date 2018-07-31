FROM alpine:3.6

LABEL maintainer="petr.pliska@post.cz"

ENV DOCKER_CLIENT_VERSION="18.05.0-ce"
ENV TERRAFORM_VERSION="0.11.7"
ENV HELM_VERSION="2.9.1"
ENV KUBECTL_VERSION="1.11.1"
ENV GOSS_VERSION="0.3.6"
ENV YQ_VERSION="2.1.1"
ENV CLOUD_SDK_VERSION 206.0.0
ENV PATH /tmp/google-cloud-sdk/bin:$PATH

WORKDIR /tmp

# Buildpack-deps basic requirements
RUN apk add --update --no-cache \
        ca-certificates \
        curl \
        gnupg \
        wget \
        tar \
        unzip && \
        # Install git vcs
        apk add --update --no-cache \
        git \
        openssl \
        openssh-client \
        bash && \
        # Install Docker client, Helm, Terraform, Kubectlx
        curl --location https://download.docker.com/linux/static/edge/x86_64/docker-$DOCKER_CLIENT_VERSION.tgz --output /tmp/docker-$DOCKER_CLIENT_VERSION.tgz && \
        tar --extract --gzip --directory /tmp --file /tmp/docker-$DOCKER_CLIENT_VERSION.tgz && \
        mv /tmp/docker/* /usr/bin && \
        rm -rf /tmp/* && \
        curl --location https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-linux-amd64.tar.gz --output helm.tar.gz && \
        tar --extract --file helm.tar.gz && \
        mv linux-amd64/helm /usr/bin/helm && \
        rm -rf linux-amd64 helm.tar.gz && \
        curl --location https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip && \
        unzip terraform.zip && \
        mv terraform /usr/bin/terraform && \
        rm -rf terraform.zip && \
        curl --location https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl --output /usr/bin/kubectl && \
        chmod +x /usr/bin/kubectl && \
        curl --location https://github.com/aelsabbahy/goss/releases/download/v$GOSS_VERSION/goss-linux-amd64 --output /usr/local/bin/goss && \
        curl --location https://raw.githubusercontent.com/aelsabbahy/goss/v$GOSS_VERSION/extras/dgoss/dgoss --output /usr/local/bin/dgoss && \
        chmod +rx /usr/local/bin/goss && \
        chmod +rx /usr/local/bin/dgoss && \
        wget --output-document=/usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/$YQ_VERSION/yq_linux_amd64 && \
        chmod +x /usr/local/bin/yq

RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version

VOLUME ["/root/.config"]
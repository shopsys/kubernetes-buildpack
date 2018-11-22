FROM alpine:3.6

ENV DOCKER_CLIENT_VERSION="18.05.0-ce"
ENV TERRAFORM_VERSION="0.11.7"
ENV KUBECTL_VERSION="1.11.1"
ENV YQ_VERSION="2.1.1"
ENV CLOUD_SDK_VERSION="206.0.0"
ENV KUSTOMIZE_VERSION="1.0.10"
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
        apk add --update --no-cache \
        git \
        bash && \
        curl --location https://download.docker.com/linux/static/edge/x86_64/docker-$DOCKER_CLIENT_VERSION.tgz --output /tmp/docker-$DOCKER_CLIENT_VERSION.tgz && \
        tar --extract --gzip --directory /tmp --file /tmp/docker-$DOCKER_CLIENT_VERSION.tgz && \
        mv /tmp/docker/* /usr/bin && \
        rm -rf /tmp/* && \
        curl --location https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip && \
        unzip terraform.zip && \
        mv terraform /usr/bin/terraform && \
        rm -rf terraform.zip && \
        curl --location https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl --output /usr/bin/kubectl && \
        chmod +x /usr/bin/kubectl && \
        wget --output-document=/usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/$YQ_VERSION/yq_linux_amd64 && \
        chmod +x /usr/local/bin/yq && \
        curl --location https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64 --output /usr/local/bin/kustomize && \
        chmod +x /usr/local/bin/kustomize

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

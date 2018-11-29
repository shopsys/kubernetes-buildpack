# Kubernetes Build Pack
Kubernetes Build pack serves to build and deploy [Shopsys Framework](https://github.com/shopsys/shopsys) application using Docker, Kubernetes, Terraform etc. that are preinstalled into Dockerfile which can be used later as an image.

## Requirements
Docker

## What it contains
[Docker](https://www.docker.com/)

[Kubernetes - kubectl](https://kubernetes.io/)

[Terraform](https://www.terraform.io/)

[Yq](https://github.com/kislyuk/yq)

[Google Cloud SDK](https://cloud.google.com/sdk/)

[Kustomize](https://github.com/kubernetes-sigs/kustomize)

## How to use
Basic concept of usage of this image is to mount your repository into container volume from which you can perform all your tasks related to deploying Shopsys Framework.

*Code example*: 

```
cd /my-project/

docker run \
    -v $PWD:/tmp \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.kube/config:/root/.kube/config \
    shopsys/kubernetes-buildpack
    --rm 
    <your scripts>
```

## How to extend
What if I want to work with some technology that is not included in shopsys/kubernetes-buildpack?

You can extend our image in `Dockerfile` and install applications and tools that you require.

```Dockerfile
FROM shopsys/kubernetes-buildpack

# install tools you want here, eg. Python
RUN apk add --update --no-cache python3
```
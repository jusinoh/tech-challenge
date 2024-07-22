# Use the latest Alpine image as the base
FROM alpine:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Install necessary packages including Docker, and other dependencies
RUN apk add --update --no-cache \
    curl \
    unzip \
    bash \
    git \
    jq \
    postgresql-client \
    docker \
    openrc \
    && rc-update add docker boot

# The openrc service management might not be fully functional in all Docker-in-Docker scenarios

# Install a specific version of AWS CLI
ENV AWS_CLI_VERSION=2.0.6
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Install Terraform
ENV TERRAFORM_VERSION=1.6.6
RUN curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Create and set permissions for the plugin cache directory
RUN mkdir -p /root/.terraform.d/plugin-cache \
    && chmod -R 755 /root/.terraform.d

# Set environment variable for the plugin cache directory
ENV TF_PLUGIN_CACHE_DIR=/root/.terraform.d/plugin-cache

# Install kubectl
ENV KUBECTL_VERSION=v1.29.0
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin

# Install Helm
ENV HELM_VERSION=v3.14.0
RUN curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64 helm-${HELM_VERSION}-linux-amd64.tar.gz

# Change ownership of the working directory to the non-root user
RUN chown -R appuser:appgroup /usr/src/app

# Switch to the non-root user
USER appuser

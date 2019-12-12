FROM centos:7

ARG TERRAFORM_VERSION="0.12.17"

# Install google-cloud-sdk
RUN sh -c 'echo -e "[google-cloud-sdk] \n\
name=Google Cloud SDK \n\
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64 \n\
enabled=1 \n\
gpgcheck=1 \n\
repo_gpgcheck=1 \n\
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg \n\
    https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" > /etc/yum.repos.d/google-cloud-sdk.repo' && \
    cat /etc/yum.repos.d/google-cloud-sdk.repo && \
    yum -y install google-cloud-sdk

# Install kubectl
RUN sh -c 'echo -e "[kubernetes] \n\
name=Kubernetes \n\
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64 \n\
enabled=1 \n\
gpgcheck=1 \n\
repo_gpgcheck=1 \n\
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" > /etc/yum.repos.d/kubernetes.repo' && \
    cat /etc/yum.repos.d/kubernetes.repo && \
    yum -y install kubectl

# Install kubemci
RUN yum -y update && yum -y install wget && \
    wget https://storage.googleapis.com/kubemci-release/release/latest/bin/linux/amd64/kubemci && \
    chmod 777 kubemci && \
    mv kubemci /usr/local/bin

# Install Terraform
RUN yum -y update && yum -y install wget unzip && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/

# Install Ansible
RUN yum -y update && yum -y install ansible

ENV GOOGLE_APPLICATION_CREDENTIALS '/credential.json'

ENTRYPOINT ["bash", "-c", "echo $GCP_SERVICE_KEY > /credential.json && bash"]

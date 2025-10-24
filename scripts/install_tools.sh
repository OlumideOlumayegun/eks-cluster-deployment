#!/bin/bash
set -e

echo "🔧 Provisioning tools for the cluster setup..."

yum --help &>> /dev/null
if [ $? -eq 0 ]
then
  yum install zip unzip -y
else
  apt update && apt install zip unzip -y
fi

echo "🔧 Updating AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

echo "🔧 Installing kubectl..."
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/
kubectl version --short --client

echo "🔧 Installing eksctl..."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

echo "✅ Installation complete."

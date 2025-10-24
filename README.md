# 🚀 Amazon EKS Cluster Deployment

This repository documents the process of provisioning and testing an **Amazon Elastic Kubernetes Service (EKS)** cluster on AWS.  
It is a complete AWS EKS (Elastic Kubernetes Service) cluster deployment project demonstrating infrastructure as code, Kubernetes orchestration, and cloud-native application deployment.
The project provides a comprehensive guide and automated scripts for deploying a fully functional EKS cluster on AWS, complete with a sample nginx application, load balancer configuration, and high-availability testing.


---

## 📌 Overview
- Provision an EKS cluster with **eksctl**
- Deploy **nginx** on Kubernetes
- Expose it via a **LoadBalancer service**
- Test **high availability** by terminating worker nodes
- Clean up all resources

---

## ⚡ Project Highlights
- **Cloud Provider:** AWS
- **Services Used:** EKS, EC2, IAM, CloudFormation
- **Tools:** AWS CLI, kubectl, eksctl
- **Application:** nginx (containerised web server)

---

## 📂 Repository Structure
```
eks-cluster-deployment/
├── README.md
├── docs/EKS_Cluster_Guide.docx
├── manifests/
│   ├── nginx-deployment.yaml
│   └── nginx-svc.yaml
├── scripts/
│   ├── install_tools.sh
│   ├── cluster_setup.sh
│   └── cleanup.sh
```

---

## ⚙️ Setup Instructions

### 1. IAM Setup

### 2. Launch EC2 Instance

### 3. Confugre AWS CLI Tool

```bash
aws --version
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
which aws
sudo ./aws/install --bin-dir /usr/bin --install-dir /usr/bin/aws-cli --update
aws --version
aws configure
```

### 4. Install kubectl and eksctl Tools

Install kubectl
```bash
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/
kubectl version --short --client
```

Install eksctl
```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

### 5. Create an EKS Cluster
```bash
eksctl create cluster --name dev --region us-east-1 --nodegroup-name standard-workers --node-type t3.micro --nodes 3 --nodes-min 1 --nodes-max 4 --managed
```

### 5. Deploy nginx
```bash
kubectl apply -f manifests/nginx-svc.yaml
kubectl apply -f manifests/nginx-deployment.yaml
```

### 6. Test Application
```bash
kubectl get service
curl "<LOAD_BALANCER_DNS>"
```

### 7. Clean Up
```bash
chmod +x scripts/cleanup.sh
./scripts/cleanup.sh
```

---

## 📊 Demo Workflow
1. Created IAM user with admin permissions.  
2. Launched EC2 instance and installed required tools.  
3. Provisioned EKS cluster with 3 worker nodes.  
4. Deployed **nginx** app on Kubernetes.  
5. Validated **LoadBalancer** external access.  
6. Tested **high availability** by stopping worker nodes.  
7. Cleaned up with `eksctl delete cluster`.  

---

## 📖 Documentation
Detailed instructions are available in [`docs/EKS_Cluster_Guide.docx`](./docs/EKS_Cluster_Guide.docx).  

---

## 👤 Author
Created by **Olumide Olumayegun** – Cloud, DevOps & AI Engineer with expertise in AWS, Kubernetes, and DevOps.

## 🙏 Acknowledgments

- AWS EKS Documentation
- Kubernetes Community
- A Cloud Guru for the original project content

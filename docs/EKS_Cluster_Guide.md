# Launching an EKS Cluster

## Introduction

Amazon Elastic Kubernetes Service (EKS) is a fully managed Kubernetes service from AWS.
In this project, I will:

* Use the AWS Command Line Interface (CLI) and AWS Console.
* Work with utilities like **eksctl** and **kubectl**.
* Launch an EKS cluster, provision a deployment and pod running **nginx**, and expose the application via a LoadBalancer service.

⚠️ **Note**: `us-east-1` can sometimes face capacity issues in specific Availability Zones (AZs). Since AZ lettering differs per AWS account, you may encounter an `UnsupportedAvailabilityZoneException`. If so, rerun `eksctl create cluster` with the `--zones` option and exclude the affected AZ. Example:

```bash
eksctl create cluster --name dev --region us-east-1 \
--zones=us-east-1a,us-east-1b,us-east-1d \
--nodegroup-name standard-workers --node-type t3.medium \
--nodes 3 --nodes-min 1 --nodes-max 4 --managed
```

---

## Step 1: Log In

Log in to AWS account and confirm you’re working in the **N. Virginia (us-east-1)** region.

---

## Step 2: Create an IAM User with Admin Permissions

1. Go to **IAM > Users**.
2. Click **Add users**.
3. Enter username: `k8-user`.
4. Click **Next**.
5. Choose **Attach policies directly** → Select **AdministratorAccess**.
6. Click **Next**, then **Create user**.
7. Open the new user `k8-user`.
8. Navigate to **Security credentials** → **Create access key**.
9. Choose **Command Line Interface (CLI)**, acknowledge, and click **Next**.
10. Click **Create access key**.
11. Copy or download the credentials for AWS CLI setup.

---

## Step 3: Launch an EC2 Instance

1. Go to **EC2 > Instances** → **Launch Instance**.
2. Select **Amazon Linux 2 AMI**.
3. Instance type: **t2.micro**.
4. Create new key pair → name it `k8ec2kp`.
5. In **Network settings** → enable **Auto-assign Public IP**.
6. Launch instance.
7. Once running, select the instance → **Connect** → **EC2 Instance Connect** → **Connect**.

---

## Step 4: Install Git and clone repo

```bash
sudo yum install -y git
git clone https://github.com/OlumideOlumayegun/eks-cluster-deployment

```
---

## Step 5: Update AWS CLI and Install kubectl and eksctl

### Update AWS CLI

```bash
aws --version
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
which aws
sudo ./aws/install --bin-dir /usr/bin --install-dir /usr/bin/aws-cli --update
aws --version
```

### Install kubectl

```bash
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

### Install eksctl

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
eksctl help
```

#### Alternatively, update AWS cli, and install eksctl and kubectl by running the **install_tool.sh** script in the terminal.

```bash
./eks-cluster-deployment/scripts/install_tool.sh
```

---

## Step 6: Configure AWS CLI

```bash
aws configure
```

* AWS Access Key ID → from earlier.
* AWS Secret Access Key → from earlier.
* Default region → `us-east-1`.
* Default output → `json`.

---

## Step 7: Provision an EKS Cluster

```bash
eksctl create cluster --name dev --region us-east-1 \
--nodegroup-name standard-workers --node-type t3.micro \
--nodes 2 --nodes-min 1 --nodes-max 4 --managed
```
#### Alternatively, provision and EKS cluster by running the **cluster_setup.sh** script in the terminal.

```bash
./eks-cluster-deployment/scripts/cluster_setup.sh
```


⏳ This takes 10–15 minutes. If capacity errors occur, retry with `--zones` as shown earlier.

Monitor progress in **CloudFormation**. You’ll see:

* A control plane stack.
* A worker node group stack.

Once complete, check in **EKS > Clusters**.

---

## Step 8: Verify Cluster

Re-connect to the EC2 instance and run:

```bash
eksctl get cluster
aws eks update-kubeconfig --name dev --region us-east-1
```

---

## Step 9: Deploy Nginx Application

### Inspect manifests

```bash
cd eks-cluster-deployment
cat manifests/nginx-deployment.yaml
cat manifests/nginx-svc.yaml
```

### Apply Service & Deployment

```bash
kubectl apply -f ./manifests/nginx-svc.yaml
kubectl get service

kubectl apply -f ./manifests/nginx-deployment.yaml
kubectl get deployment
kubectl get pod
kubectl get rs
kubectl get node
```

### Test LoadBalancer

Copy external DNS from service and test:

```bash
curl "<LOAD_BALANCER_DNS_HOSTNAME>"
```

You should see the default **Nginx HTML page**.
Open the same DNS in a browser to confirm.

---

## Step 10: Test High Availability

1. In EC2, stop worker node instances.
2. Wait a few minutes while EKS launches replacements.

Check status:

```bash
kubectl get node
kubectl get pod
```

Eventually, new nodes and pods will become **Ready**.

Re-test the LoadBalancer:

```bash
kubectl get service
curl "<LOAD_BALANCER_DNS_HOSTNAME>"
```

---

## Step 9: Clean Up

```bash
eksctl delete cluster dev --region us-east-1
```

or run script:
```bash
./scripts/cleanup.sh
```

---

## Conclusion

I successfully:

* Created an IAM user and EC2 instance.
* Installed and configured AWS CLI, kubectl, and eksctl.
* Provisioned an EKS cluster.
* Deployed an nginx app and verified high availability.
* Cleaned up resources.

---
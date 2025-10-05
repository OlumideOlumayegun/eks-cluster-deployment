#!/bin/bash
set -e

CLUSTER_NAME="dev"
REGION="us-east-1"

echo "🧹 Deleting EKS cluster: $CLUSTER_NAME"
eksctl delete cluster --name $CLUSTER_NAME --region $REGION
echo "✅ Cleanup complete."

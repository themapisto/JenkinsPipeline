curl -O https://s3.ap-northeast-2.amazonaws.com/cloudformation.cloudneta.net/K8S/eks-oneclick-new.yaml

# oidc provider 
CLUSTER_NAME="myeks"
eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER_NAME} --approve

# controller install
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json

# IAM SA create
POLICY_ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AWSLoadBalancerControllerIAMPolicy`].Arn' --output text)
ROLE_NAME="AmazonEKSLoadBalancerControllerRole"
CLUSTER_NAME="${CLUSTER_NAME}"

eksctl create iamserviceaccount \
  --cluster ${CLUSTER_NAME} \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name ${ROLE_NAME} \
  --attach-policy-arn=${POLICY_ARN} \
  --approve


# repo
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=${CLUSTER_NAME} \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

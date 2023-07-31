# oidc provider create
#  

CLUSTER_NAME="myeks"
eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER_NAME} --approve

# oidc provider describe
#
aws eks describe-cluster --name myeks --query cluster.identity.oidc.issuer --output text
# https://oidc.eks.ap-northeast-2.amazonaws.com/id/84AE1BFB78134E261CCBD36E08A2C2CF


#  IAM role
#
aws iam list-policies --query 'Policies[?PolicyName==`AmazonS3ReadOnlyAccess`].Arn'


# IRSA
# 
eksctl create iamserviceaccount \
    --name iam-test \
    --namespace workshop \
    --cluster myeks \
    --attach-policy-arn arn\:aws\:iam::aws\:policy/AmazonS3ReadOnlyAccess \
    --approve \
    --override-existing-serviceaccounts



node { 
  stage('========== Clone repository ==========') { 
    checkout scm 
}
  environment {
    AWS_ACCESS_KEY_ID = credentials('awsAccessKeyID')
    AWS_SECRET_ACCESS_KEY = credentials('awsSecretAccessKey')
    AWS_DEFAULT_REGION = 'us-east-2'
  }

  stage('========== Build image ==========') { 
        kubernetesDeploy configs: "test.yaml", kubeconfigId: 'Kubeconfig'
        sh "kubectl apply -f test.yaml"
}
 
  } 


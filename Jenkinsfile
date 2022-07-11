


node { 
  stage('========== Clone repository ==========') { 
    checkout scm 
} 
  stage('========== Build image ==========') { 
        kubernetesDeploy configs: "test.yaml", kubeconfigId: 'Kubeconfig'
}
 
  } 


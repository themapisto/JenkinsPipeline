


node { 
  stage('========== Clone repository ==========') { 
    checkout scm 
} 

#  stage('SonarQube Analysis') {
#    def mvn = tool 'Devops'
#    withSonarQubeEnv() {
#      sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=Koo"
#    }
#  }

  stage('========== Build image ==========') { 
    app = docker.build("tanzu/${env.IMAGE_NAME}") 
} 
  stage('========== Push image ==========') { 
    docker.withRegistry('https://core.harbor.domain:32120', 'harbor') { 
      app.push("${env.BUILD_NUMBER}") 
      app.push("latest") 
}

    stage('Kubernetes deploy') {
        kubernetesDeploy configs: "test_koo.yaml", kubeconfigId: 'kubeconfig'
    }

    stage('Complete') {
        sh "echo 'The end'"
    }


 
  } 
}


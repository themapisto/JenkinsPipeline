


node { 
  stage('========== Clone repository ==========') { 
    checkout scm 
} 
  stage('========== Build image ==========') { 
    app = docker.build("${env.IMAGE_NAME}") 
} 
  stage('========== Push image ==========') { 
    docker.withRegistry('http://localhost:80', 'harbor') { 
      app.push("${env.BUILD_NUMBER}") 
      app.push("latest") 
    } 
  } 
}



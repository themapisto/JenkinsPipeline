


node { 
  stage('========== Clone repository ==========') { 
    checkout scm 
} 
  stage('========== Build image ==========') { 
    app = docker.build("tanzu/${env.IMAGE_NAME}") 
} 
  stage('========== Push image ==========') { 
    docker.withRegistry('https://18.179.50.58:32120', 'harbor') { 
      app.push("${env.BUILD_NUMBER}") 
      app.push("latest") 
}
 
  } 
}


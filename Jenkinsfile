


node { 
  stage('========== Clone repository ==========') { 
    checkout scm 
} 
  stage('========== Build image ==========') { 
    app = docker.build("koomzc2/${env.IMAGE_NAME}") 
} 
  stage('========== Push image ==========') { 
    docker.withRegistry('https://harbor02.test.com', 'harboradmin') { 
      app.push("${env.BUILD_NUMBER}") 
      app.push("latest") 
    } 
  } 
}






node { 
  stage('========== Clone repository ==========') { 
    checkout scm 
} 
  stage('========== Build image ==========') { 
    app = docker.build("koomzc2/${env.IMAGE_NAME}") 
} 
  stage('========== Push image ==========') { 
    docker.withRegistry('http://192.168.10.33', 'harbor') { 
      app.push("${env.BUILD_NUMBER}") 
      app.push("latest") 
    } 
  } 
}



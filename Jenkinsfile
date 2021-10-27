


node { 
  stage('========== Clone repository ==========') { 
    checkout scm 
} 
  stage('========== Build image ==========') { 
    app = docker.build("koomzc/koo") 
} 
  stage('========== Push image ==========') { 
    docker.withRegistry('', 'koomzc') { 
      app.push("${env.BUILD_NUMBER}") 
      app.push("latest") 
    } 
  } 
}



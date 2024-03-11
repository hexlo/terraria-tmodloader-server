pipeline {
  environment {
    userName = "hexlo"
    imageName = "terraria-tmodloader-server"
    imageTag = 'latest'
    githubTag = ''
    gitBranch = '1.4.4'
    gitRepo = "https://github.com/${userName}/${imageName}.git"
    dockerhubRegistry = "${userName}/${imageName}"
    githubRegistry = "ghcr.io/${userName}/${imageName}"
    
    dockerhubCredentials = 'DOCKERHUB_TOKEN'
    githubCredentials = 'GITHUB_TOKEN'
    
    dockerhubImage = ''
    githubImage = ''
    
    versionTag = ''
    terrariaVersion = ''
  }
  agent any
  triggers {
    cron('H H/2 * * *')
  }
  stages {
    stage('Cloning Git') {
      steps {
        git branch: gitBranch, credentialsId: 'GITHUB_TOKEN', url: gitRepo
      }
    }
    stage('Building image') {
      steps{
        script {
          terrariaVersion = sh(script: "${WORKSPACE}/.scripts/get-terraria-version.sh", , returnStdout: true).trim()
          echo "terrariaVersion=${terrariaVersion}"
          // Docker Hub
          dockerhubImage = docker.build( "${dockerhubRegistry}:${imageTag}", "--no-cache ." )
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          // Docker Hub
          docker.withRegistry( '', "${dockerhubCredentials}" ) {
            dockerhubImage.push()
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
          sh "docker system prune --force --volumes"
        }
      }
    }
  }
}

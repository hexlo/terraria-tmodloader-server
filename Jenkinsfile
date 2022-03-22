pipeline {
  environment {
    userName = "hexlo"
    imageName = "terraria-tmodloader-server"
    imageTag = 'latest'
    githubTag = ''
    gitBranch = 'main'
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
    cron('H H(4-6) * * *')
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

          date = sh "date +%Y-%m-%d:%H:%M:%S"
          echo "date=${date}"

          terrariaVersion = sh(script: "${WORKSPACE}/.scripts/get-terraria-version.sh", , returnStdout: true).trim()
          echo "terrariaVersion=${terrariaVersion}"

          tmodloaderVersion = sh(script: "${WORKSPACE}/.scripts/get-mod-version.sh https://github.com/tModLoader/tModLoader/releases/latest", , returnStdout: true).trim()
          echo "tmodloaderVersion=${tmodloaderVersion}"

          githubTag = sh(script: "git tag --sort version:refname | tail -1", , returnStdout: true).trim()
          echo "githubTag=${githubTag}"

          // Docker Hub
          dockerhubImage = docker.build( "${dockerhubRegistry}:${imageTag}", "--no-cache --build-arg CACHE_DATE=$date ." )
          // Github
          githubImage = docker.build( "${githubRegistry}:${imageTag}", "--no-cache --build-arg CACHE_DATE=$date ." )
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          // Docker Hub
          // Check if DockerHub tag exists
          canPushDHTag = sh(script: "docker manifest inspect ${dockerhubRegistry}:${githubTag} > /dev/null 2>&1; echo \$?", , returnStdout: true).trim()
          echo "canPushDockerhubTag=${canPushDockerhubTag}"

          docker.withRegistry( '', "${dockerhubCredentials}" ) {
            dockerhubImage.push()

            if (canPushDockerhubTag) {
              dockerhubImage.push("${githubTag}")
            }
          }

          // Github
          // Check if Github tag exists
          canPushGithubTag = sh(script: "docker manifest inspect ${githubRegistry}:${githubTag} > /dev/null 2>&1; echo \$?", , returnStdout: true).trim()
          echo "canPushGithubTag=${canPushGithubTag}"

          docker.withRegistry("https://${githubRegistry}", "${githubCredentials}" ) {
            githubImage.push()
            
            if (canPushGithubTag) {
              githubImage.push("${githubTag}")
            }
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
          sh "docker system prune -f"
          // // Docker Hub
          // sh "docker rmi ${dockerhubRegistry}:${imageTag}"
        
          // // Github
          // sh "docker rmi ${githubRegistry}:${imageTag}"
        }
      }
    }
  }
  post {
    failure {
        mail bcc: '', body: "<b>Jenkins Build Report</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} \
         <br>Branch: ${env.BRANCH_NAME}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', \
        subject: "Jenkins Build Failed: ${env.JOB_NAME}", to: "jenkins@mindlab.dev";  

    }
  }
}

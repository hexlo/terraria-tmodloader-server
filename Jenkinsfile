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

          terrariaVersion = sh(script: "${WORKSPACE}/.scripts/get-terraria-version.sh", returnStdout: true).trim()
          echo "terrariaVersion=${terrariaVersion}"

          tmodloaderVersion = sh(script: "${WORKSPACE}/.scripts/get-mod-version.sh https://github.com/tModLoader/tModLoader/releases/latest", , returnStdout: true).trim()
          echo "tmodloaderVersion=${tmodloaderVersion}"

          // githubTag = '1.3-latest'
          githubTag = sh(script: "git tag --sort version:refname | tail -1 | sed 's#v##'", returnStdout: true).trim()
          echo "githubTag=${githubTag}"

          // Docker Hub
          dockerhubImage = docker.build( "${dockerhubRegistry}:${imageTag}", "--no-cache ." )
          // Github
          githubImage = docker.build( "${githubRegistry}:${imageTag}", "--no-cache ." )
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {

          // Docker Hub
          // Check if DockerHub tag exists. We don' want to overwrite version tags
          sh "! docker manifest inspect ${dockerhubRegistry}:${githubTag} > /dev/null 2>&1; echo \$? > cmdOut"
          canPushDockerhubTag = readFile('cmdOut').trim() == 0 ?  true : false
          echo "canPushDockerhubTag: ${canPushDockerhubTag}"

          docker.withRegistry( '', "${dockerhubCredentials}" ) {
            dockerhubImage.push()

            if (canPushDockerhubTag) {
              dockerhubImage.push("${githubTag}")
            }
          }

          // Github
          // Check if Github tag exists. We don' want to overwrite version tags
          sh "! docker manifest inspect ${githubRegistry}:${githubTag} > /dev/null 2>&1; echo \$? > cmdOut"
          canPushGithubTag = readFile('cmdOut').trim() == 0 ?  true : false
          echo "canPushGithubTag: ${canPushGithubTag}"

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

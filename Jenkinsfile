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
          sh "! docker manifest inspect ${dockerhubRegistry}:${githubTag} > /dev/null 2>&1; echo \$? > cmdOut_docker"
          def fout_docker = readFile('cmdOut_docker').trim()
          println(fout_docker)
          canPushDockerhubTag = readFile('cmdOut_docker').trim() == '0' ?  true : false
          echo "canPushDockerhubTag: ${canPushDockerhubTag}"

          docker.withRegistry( '', "${dockerhubCredentials}" ) {
            dockerhubImage.push()

            if (canPushDockerhubTag) {
              dockerhubImage.push("${githubTag}")
            }
          }

          // Github
          // Check if Github tag exists. We don' want to overwrite version tags
          sh"! docker manifest inspect ${githubRegistry}:${githubTag} > /dev/null 2>&1; echo \$? > cmdOut_github"
          def fout_github = readFile('cmdOut_github').trim()
          println(fout_github)
          canPushGithubTag = readFile('cmdOut_github').trim() == '0' ?  true : false
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
          sh "docker system prune --force --volumes"
        }
      }
    }
  }
  post {
    failure {
        mail bcc: '', body: "<b>Jenkins Build Report</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} \
         <br>Branch: ${env.BRANCH_NAME}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', \
        subject: "Jenkins Build Failed: ${env.JOB_NAME}", to: "jenkins@runx.io";
    }
  }
}

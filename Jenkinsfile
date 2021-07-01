pipeline {
  agent {
    label 'X86-64-MULTI'
  }

  environment {
    CONTAINER_NAME = 'tkf-docker-cacti'
    TKF_USER = 'teknofile'

    LOCAL_DOCKER_PROXY="docker.copperdale.teknofile.net"
    SCAN_SCRIPT="https://nexus.copperdale.teknofile.net/repository/teknofile-utils/teknofile/ci/utils/tkf-inline-scan-v0.6.0-1.sh"

    DOCKER_CLI_EXPERIMENTAL='enabled'
  }

  stages {
    stage('Setup enviornment and Start ') {
      steps {
        slackSend (color: '#ffff00', message: "STARTED: Job '${env.JOB_NAME}' [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")

        script {
          env.EXIT_STATUS = ''

          env.CURR_DATE = sh(
            script: '''date '+%Y-%m-%dT%H:%M:%S%:z' ''',
            returnStdout: true).trim()

          env.GITHASH_LONG = sh(
            script: '''git log -1 --format=%H''',
            returnStdout: true).trim()

          env.GITHASH_SHORT = sh(
            script: '''git log -1 --format=%h''',
            returnStdout: true).trim()

        }
    }
    stage('Docker Linting') {
      steps {
	sh '''
	  docker run --rm -i ${LOCAL_DOCKER_PROXY}/hadolint/hadolint < Dockerfile || true
	'''
      }
    }
    stage('Build and Publish') {
      steps {
	script {
	  withDockerRegistry(credentialsId: 'teknofile-docker-creds') {
	    sh '''
		docker buildx create --use --name mybuilder-${CONTAINER_NAME}
		docker buildx build -t ${TKF_USER}/${CONTAINER_NAME} --platform=linux/arm,linux/arm64,linux/amd64 . --push
		docker buildx rm mybuilder-${CONTAINER_NAME}
	    '''
	  }
	}
      }
    }
    stage('Image Scan') {
      steps {
        sh 'curl -s ${SCAN_SCRIPT} | bash -s -- -t 1800 -r -p ${LOCAL_DOCKER_PROXY}/${TKF_USER}/${CONTAINER_NAME}:${GITHASH_LONG}'
      }
    }
  }
  post { 
    success {
      slackSend(color: '#00FF00', message: 'SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' ($env.BUILD_URL})")
    }
    failure {
      slackSend(color: '#FF0000', message: 'FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' ($env.BUILD_URL})")
    }
  }
}

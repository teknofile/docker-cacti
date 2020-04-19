pipeline {
  agent {
    label 'X86-64-MULTI'
  }

  environment {
    CONTAINER_NAME = 'tkf-docker-cacti'
    TKF_USER = 'teknofile'

  }

  stages {
    // Run SHellCheck
    stage('ShellCheck') {
      steps {
        sh '''echo "TODO: Determine a good strategy for finding and scanning shell code"'''
      }
    }
    stage('Docker Linting') {
      steps {
        sh '''echo "TODO: Determine a good strategy for linting a Dockerfile"'''
      }
    }
    stage('Enabling and Building Buildx') {
      steps {
        sh '''
          export DOCKER_CLI_EXPERIMENTAL=enabled
          export DOCKER_BUILDKIT=1
          docker build --platform=local -o . git://github.com/docker/buildx
          mkdir -p ~/.docker/cli-plugins && mv buildx ~/.docker/cli-plugins/docker-buildx
        '''
      }
    }
  }
}

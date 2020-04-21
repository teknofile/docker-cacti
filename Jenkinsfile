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
        // Enable binfmt_misc to run non-native Docker images
        sh '''
          docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
        '''
        // Switch from the default Docker builder to a multi-arch builder
        //sh '''
        // docker buildx create --use --name mybuilder
        // docker buildx ls
        // '''
      }
    }
    stage('Build and Publish') {
      steps {
        sh '''
          docker buildx build -t ${TKF_USER}/${CONTAINER_NAME} --platform=linux/arm,linux/arm64,linux/amd64 . --push
          '''
      }
//      steps {
//        sh '''
//          docker stop buildx_buildkit_mybuilder0
//          docker rm buildx_buildkit_mybuilder0
//        '''
//      }
    }
  }
}

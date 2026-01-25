pipeline {
  agent {
    kubernetes {
      label 'kaniko'
      defaultContainer 'kaniko'
    }
  }

  environment {
    REGISTRY = "nexus-docker-service.eks-build.svc.cluster.local:8082"
    IMAGE_NAME = "app-backend"
    IMAGE_TAG = "latest"
    DOCKER_CONFIG = "/kaniko/.docker"
  }

  stages {

    stage('Build & Push Image') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor \
              --context=application \
              --dockerfile=application/Dockerfile \
              --destination=${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} \
              --insecure \
              --skip-tls-verify
          '''
        }
      }
    }

  }
}

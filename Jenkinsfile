pipeline {
  agent {
    kubernetes {
      yamlFile 'Jenkins/pod.yaml'
    }
  }

  environment {
    AWS_ACCOUNT_ID = "985539792593"
    AWS_REGION     = "us-east-1"
    IMAGE_TAG      = "${BUILD_NUMBER}"
  }

  stages {

    stage('Build & Push Image') {
      steps {
        container('kaniko') {
          sh """
            /kaniko/executor \
              --dockerfile=application/Dockerfile \
              --context=application \
              --destination=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/app-backend:${IMAGE_TAG}
          """
        }
      }
    }

    stage('Deploy to DEV') {
      steps {
        container('helm') {
          sh """
            helm upgrade --install app helm/app \
              -n ci \
              --set backend.image.tag=${IMAGE_TAG}
          """
        }
      }
    }
  }
}

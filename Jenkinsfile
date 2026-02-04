pipeline {
  agent {
    kubernetes {
      yamlFile 'Jenkins/pod.yaml'
    }
  }

  environment {
    AWS_ACCOUNT_ID = "985539792593"
    AWS_REGION     = "us-east-1"
    ECR_REPO       = "app-backend"
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
              --destination=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/app-backend:${BUILD_NUMBER} \
              --verbosity=info \
              --push-retry=3 \
              --use-new-run \
              --oci-layout-path=/kaniko/oci \
              --snapshotMode=redo
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

    stage('Approve PROD') {
      agent none
      steps {
        input message: 'Deploy to PROD?', ok: 'Deploy'
      }
    }

    stage('Deploy to PROD') {
      steps {
        container('helm') {
          sh """
            helm upgrade --install app helm/app \
              -n prod \
              --values helm/app/values-prod.yaml.j2 \
              --set backend.image.tag=${IMAGE_TAG}
          """
        }
      }
    }
  }
}

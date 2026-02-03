pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ["/busybox/cat"]
    tty: true
    env:
    - name: AWS_REGION
      value: us-east-1
    - name: AWS_SDK_LOAD_CONFIG
      value: "true"
  - name: helm
    image: alpine/helm:3.14.4
    command: ["/bin/sh"]
    args: ["-c", "cat"]
    tty: true
"""
    }
  }

  parameters {
    choice(
      name: 'ENV',
      choices: ['dev', 'prod'],
      description: 'Deployment environment'
    )
  }

  environment {
    AWS_ACCOUNT_ID = "985539792593"
    AWS_REGION     = "us-east-1"
    ECR_REPO       = "app-backend"
    IMAGE_TAG      = "${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Image') {
      steps {
        container('kaniko') {
          sh '''
            echo "=== BUILD & PUSH IMAGE ==="

            /kaniko/executor \
              --dockerfile=application/Dockerfile \
              --context=application \
              --destination=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Deploy to Dev') {
      when {
        expression { params.ENV == 'dev' }
      }
      steps {
        container('helm') {
          sh '''
            helm upgrade --install app helm/app \
              -n ci \
              -f helm/app/values-dev.yaml \
              --set backend.image.tag=${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Approve Prod Deployment') {
      when {
        expression { params.ENV == 'prod' }
      }
      steps {
        input message: "Deploy to PRODUCTION?"
      }
    }

    stage('Deploy to Prod') {
      when {
        expression { params.ENV == 'prod' }
      }
      steps {
        container('helm') {
          sh '''
            helm upgrade --install app helm/app \
              -n prod \
              --create-namespace \
              -f helm/app/values-prod.yaml \
              --set backend.image.tag=${IMAGE_TAG}
          '''
        }
      }
    }
  }

  post {
    success {
      echo "Pipeline finished successfully"
    }
    failure {
      echo "Pipeline failed"
    }
  }
}

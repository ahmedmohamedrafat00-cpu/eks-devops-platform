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
    command:
    - cat
    tty: true
"""
    }
  }

  environment {
    AWS_REGION = "us-east-1"
    ECR_REPO   = "985539792593.dkr.ecr.us-east-1.amazonaws.com/eks-devops-app"
    IMAGE_TAG  = "${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Image (Kaniko)') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor \
              --context $(pwd) \
              --dockerfile Dockerfile \
              --destination $ECR_REPO:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh '''
          helm upgrade --install app ./helm/app \
            --namespace apps \
            --create-namespace \
            --set image.repository=$ECR_REPO \
            --set image.tag=$IMAGE_TAG
        '''
      }
    }
  }
}

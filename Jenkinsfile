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
    - /busybox/cat
    tty: true
    env:
    - name: AWS_REGION
      value: us-east-1
    - name: AWS_SDK_LOAD_CONFIG
      value: "true"
    - name: AWS_EC2_METADATA_DISABLED
      value: "true"
    volumeMounts:
    - name: aws-token
      mountPath: /var/run/secrets/eks.amazonaws.com/serviceaccount
      readOnly: true
  volumes:
  - name: aws-token
    projected:
      sources:
      - serviceAccountToken:
          path: token
          expirationSeconds: 86400
          audience: sts.amazonaws.com
"""
    }
  }

  environment {
    AWS_ACCOUNT_ID = "985539792593"
    AWS_REGION     = "us-east-1"
    ECR_REPO       = "app-backend"
    IMAGE_TAG      = "${BUILD_NUMBER}"
  }

  stages {
    stage('Build & Push Backend Image to ECR') {
      steps {
        container('kaniko') {
          sh '''
            echo "=== BUILD & PUSH TO ECR ==="

            export AWS_ROLE_ARN=$(cat /var/run/secrets/eks.amazonaws.com/serviceaccount/..data/.. | true)
            
            /kaniko/executor \
              --dockerfile=application/Dockerfile \
              --context=application \
              --destination=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG} \
              --verbosity=info
          '''
        }
      }
    }
  }
}

pipeline {
  agent any

  parameters {
    choice(name: 'ENVIRONMENT', choices: ['dev', 'test'], description: 'Target environment')
  }

  environment {
    AWS_REGION     = 'us-east-1'
    AWS_ACCOUNT_ID = '985539792593'
    ECR_REGISTRY   = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

    BACKEND_REPO   = 'app-backend'
    FRONTEND_REPO  = 'app-frontend'

    IMAGE_TAG      = "build-${BUILD_NUMBER}-${params.ENVIRONMENT}"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build Backend') {
      steps {
        dir('application') {
          sh 'mvn -B -DskipTests clean package'
        }
      }
    }

    stage('Build Frontend') {
      steps {
        dir('application/frontend') {
          sh 'npm ci'
          sh 'npm run build'
        }
      }
    }

    stage('Run Tests') {
      steps {
        dir('application') {
          sh 'mvn -B test'
        }
      }
    }

    stage('ECR Login') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
          sh '''
            set -e
            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
          '''
        }
      }
    }

    stage('Build & Push Images') {
      steps {
        sh '''
          set -e
          docker build -t ${ECR_REGISTRY}/${BACKEND_REPO}:${IMAGE_TAG} -f application/Dockerfile application
          docker build -t ${ECR_REGISTRY}/${FRONTEND_REPO}:${IMAGE_TAG} -f application/frontend/Dockerfile application/frontend

          docker push ${ECR_REGISTRY}/${BACKEND_REPO}:${IMAGE_TAG}
          docker push ${ECR_REGISTRY}/${FRONTEND_REPO}:${IMAGE_TAG}
        '''
      }
    }

    stage('Deploy via Ansible (via Bastion)') {
      steps {
        script {
          def BASTION_IP = sh(script: "terraform -chdir=terraform/servers-setup output -raw bastion_public_ip", returnStdout: true).trim()
          def CONTROLLER_IP = sh(script: "terraform -chdir=terraform/servers-setup output -raw controller_private_ip", returnStdout: true).trim()

          sshagent(credentials: ['deployer-one-ssh']) {
            sh """
              set -e
              ssh -tt -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \\
                -o ProxyCommand="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p ec2-user@${BASTION_IP}" \\
                ec2-user@${CONTROLLER_IP} \\
                'cd ~/eks-devops-platform/ansible && \\
                 ansible-playbook -i inventory/hosts.generated.ini playbooks/deploy-helm.yml \\
                   -e env=${ENVIRONMENT} \\
                   -e ecr.image_tag=${IMAGE_TAG}'
            """
          }
        }
      }
    }
  }

  post {
    always {
      echo "Image tag: ${IMAGE_TAG}"
    }
  }
}

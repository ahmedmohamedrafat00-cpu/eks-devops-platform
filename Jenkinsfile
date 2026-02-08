pipeline {
  agent {
    kubernetes {
      yamlFile 'Jenkins/pod.yaml'
    }
  }

  parameters {
    choice(name: 'ENVIRONMENT', choices: ['dev', 'test', 'prod'], description: 'Target environment')
  }

  environment {
    AWS_ACCOUNT_ID = "985539792593"
    AWS_REGION     = "us-east-1"
    IMAGE_REPO     = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/app-backend"
    IMAGE_TAG      = "${BUILD_NUMBER}"
  }

  stages {
    stage('Print Info') {
      steps {
        echo "ENVIRONMENT=${params.ENVIRONMENT}"
        echo "IMAGE=${env.IMAGE_REPO}:${env.IMAGE_TAG}"
      }
    }

    stage('Build & Push Backend Image (ECR)') {
      steps {
        container('kaniko') {
          sh """
            /kaniko/executor \
              --dockerfile=application/Dockerfile \
              --context=application \
              --destination=${IMAGE_REPO}:${IMAGE_TAG}
          """
        }
      }
    }

    stage('Deploy via Ansible (SSH through Bastion)') {
      steps {
        container('helm') {
          withCredentials([
            string(credentialsId: 'bastion-ip', variable: 'BASTION_IP'),
            string(credentialsId: 'ansible-private-ip', variable: 'ANSIBLE_PRIVATE_IP')
          ]) {
            sshagent(credentials: ['ansible-ssh-key']) {
              sh '''
                set -e
                apk add --no-cache openssh-client


                KNOWN_HOSTS="$WORKSPACE/known_hosts"
                rm -f "$KNOWN_HOSTS"
                touch "$KNOWN_HOSTS"
                chmod 600 "$KNOWN_HOSTS"


                ssh \
                  -o StrictHostKeyChecking=no \
                  -o UserKnownHostsFile="$KNOWN_HOSTS" \
                  -o GlobalKnownHostsFile=/dev/null \
                  -o LogLevel=ERROR \
                  -o ProxyJump="ec2-user@$BASTION_IP" \
                  ec2-user@"$ANSIBLE_PRIVATE_IP" \
                  "cd ~/eks-devops-platform && ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy-helm.yml -e deploy_env=dev -e image_tag=${IMAGE_TAG}"
              '''
            }
          }
        }
      }
    }
  }
}

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


                # 1) install openssh client tools (ssh + ssh-keyscan) inside helm container
                apk add --no-cache openssh-client >/dev/null


                # 2) build a known_hosts file for both bastion + ansible server
                KNOWN_HOSTS="$WORKSPACE/known_hosts"
                rm -f "$KNOWN_HOSTS"
                touch "$KNOWN_HOSTS"
                chmod 600 "$KNOWN_HOSTS"


                # add bastion host key (public)
                ssh-keyscan -H "$BASTION_IP" >> "$KNOWN_HOSTS" 2>/dev/null || true


                # add ansible server host key (private, through bastion route still ok)
                ssh-keyscan -H "$ANSIBLE_PRIVATE_IP" >> "$KNOWN_HOSTS" 2>/dev/null || true


                # 3) run deploy via ssh through bastion using that known_hosts
                ssh \
                  -o UserKnownHostsFile="$KNOWN_HOSTS" \
                  -o GlobalKnownHostsFile=/dev/null \
                  -o StrictHostKeyChecking=yes \
                  -o ProxyJump="ec2-user@$BASTION_IP" \
                  ec2-user@"$ANSIBLE_PRIVATE_IP" \
                  "cd ~/eks-devops-platform && ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy-helm.yml -e deploy_env=${ENVIRONMENT} -e image_tag=${IMAGE_TAG}"
              '''
            }
          }
        }
      }
    }
  }
}

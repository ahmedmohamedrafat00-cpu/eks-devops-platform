pipeline {
    agent any

    environment {
        SSH_CREDENTIALS_ID = 'eks-devops-ssh'
        ANSIBLE_USER       = 'ec2-user'
        ANSIBLE_DIR        = 'ansible'
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Verify SSH Key Loaded') {
            steps {
                sshagent(credentials: ["${SSH_CREDENTIALS_ID}"]) {
                    sh '''
                      echo "SSH agent loaded successfully"
                      ssh -V
                    '''
                }
            }
        }

        stage('Validate Ansible Structure') {
            steps {
                sh '''
                  ansible --version
                  ls -la ${ANSIBLE_DIR}
                '''
            }
        }

        stage('Dry Run (Inventory Only)') {
            steps {
                sh '''
                  echo "Inventory preview:"
                  cat ${ANSIBLE_DIR}/inventory/hosts.ini || true
                '''
            }
        }
    }

    post {
        success {
            echo 'Stage B1 completed successfully'
        }
        failure {
            echo 'Stage B1 failed'
        }
    }
}

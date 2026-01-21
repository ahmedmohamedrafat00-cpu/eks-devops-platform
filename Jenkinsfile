pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"

        // Nexus Docker Registry
        NEXUS_REGISTRY = "nexus.local:8082"
        BACKEND_IMAGE  = "${NEXUS_REGISTRY}/app-backend"
        FRONTEND_IMAGE = "${NEXUS_REGISTRY}/app-frontend"

        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Docker Login to Nexus') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'nexus-credentials',
                        usernameVariable: 'NEXUS_USER',
                        passwordVariable: 'NEXUS_PASS'
                    )
                ]) {
                    sh '''
                        echo $NEXUS_PASS | docker login $NEXUS_REGISTRY \
                          -u $NEXUS_USER --password-stdin
                    '''
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                sh '''
                  docker build \
                    -t ${BACKEND_IMAGE}:${IMAGE_TAG} \
                    -t ${BACKEND_IMAGE}:latest \
                    application
                '''
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh '''
                  docker build \
                    -t ${FRONTEND_IMAGE}:${IMAGE_TAG} \
                    -t ${FRONTEND_IMAGE}:latest \
                    application/frontend
                '''
            }
        }

        stage('Push Images to Nexus') {
            steps {
                sh '''
                  docker push ${BACKEND_IMAGE}:${IMAGE_TAG}
                  docker push ${BACKEND_IMAGE}:latest

                  docker push ${FRONTEND_IMAGE}:${IMAGE_TAG}
                  docker push ${FRONTEND_IMAGE}:latest
                '''
            }
        }
    }

    post {
        success {
            echo "Images pushed successfully to Nexus"
        }
        failure {
            echo "CI pipeline failed"
        }
    }
}

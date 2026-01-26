pipeline {
  agent {
    kubernetes {
      label "backend-pipeline-${UUID.randomUUID().toString()}"
      defaultContainer 'jnlp'

      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    role: ci
spec:
  serviceAccountName: jenkins
  nodeSelector:
    role: ci
  tolerations:
  - key: "ci"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
      - /busybox/cat
    tty: true
    volumeMounts:
      - name: docker-config
        mountPath: /kaniko/.docker
      - name: workspace-volume
        mountPath: /home/jenkins/agent
  volumes:
  - name: docker-config
    secret:
      secretName: nexus-docker-config
  - name: workspace-volume
    emptyDir: {}
"""
    }
  }

  environment {
    NEXUS_REGISTRY = "nexus-docker-service.eks-build.svc.cluster.local:8082"
    IMAGE_NAME     = "app-backend"
    IMAGE_TAG      = "latest"
  }

  stages {

    stage('Checkout SCM') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Backend Image') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor \
              --dockerfile=application/Dockerfile \
              --context=application \
              --destination=${NEXUS_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} \
              --insecure \
              --skip-tls-verify
          '''
        }
      }
    }
  }

  post {
    success {
      echo "Image pushed successfully to Nexus"
    }
    failure {
      echo "Build or Push failed"
    }
  }
}

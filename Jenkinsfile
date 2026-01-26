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
    volumeMounts:
    - name: docker-config
      mountPath: /kaniko/.docker
  volumes:
  - name: docker-config
    secret:
      secretName: nexus-docker-config
      items:
      - key: .dockerconfigjson
        path: config.json
"""
    }
  }

  stages {
    stage('Build & Push Backend Image') {
      steps {
        container('kaniko') {
          sh '''
          echo "=== CHECK DOCKER CONFIG ==="
          ls -l /kaniko/.docker
          cat /kaniko/.docker/config.json

          echo "=== BUILD & PUSH ==="
          /kaniko/executor \
            --dockerfile=application/Dockerfile \
            --context=application \
            --destination=nexus-docker-service.eks-build:8082/app-backend:latest \
            --insecure \
            --skip-tls-verify
          '''
        }
      }
    }
  }
}

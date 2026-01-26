pipeline {
  agent {
    kubernetes {
      defaultContainer 'kaniko'
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
  volumes:
  - name: docker-config
    secret:
      secretName: nexus-docker-config
"""
    }
  }

  stages {
    stage('Build & Push Backend Image') {
      steps {
        sh '''
        /kaniko/executor \
          --dockerfile=application/Dockerfile \
          --context=application \
          --destination=nexus-docker-service.eks-build.svc.cluster.local:8082/app-backend:latest \
          --insecure \
          --skip-tls-verify
        '''
      }
    }
  }
}

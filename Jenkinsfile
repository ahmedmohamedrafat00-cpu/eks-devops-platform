pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:debug
      resources:
        requests:
          cpu: "500m"
          memory: "1Gi"
        limits:
          cpu: "1"
          memory: "2Gi"
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

  environment {
    IMAGE_NAME = "nexus-docker-service.eks-build.svc.cluster.local:8082/app-backend"
    IMAGE_TAG  = "1.0.0"
  }

  stages {
    stage('Build & Push Image') {
      steps {
        container('kaniko') {
          sh '''
          /kaniko/executor \
            --dockerfile=application/Dockerfile \
            --context=git://https://github.com/ahmedmohamedrafat00-cpu/eks-devops-platform.git \
            --destination=${IMAGE_NAME}:${IMAGE_TAG} \
            --insecure \
            --skip-tls-verify
          '''
        }
      }
    }
  }
}

resource "kubernetes_namespace" "eks_build" {
  provider = kubernetes.eks

  metadata {
    name = "eks-build"
  }
}

resource "kubernetes_storage_class" "gp2_immediate" {
  provider = kubernetes.eks

  metadata {
    name = "gp2-immediate"
  }

  storage_provisioner    = "kubernetes.io/aws-ebs"
  reclaim_policy         = "Delete"
  volume_binding_mode    = "Immediate"
  allow_volume_expansion = true

  parameters = {
    type   = "gp2"
    fsType = "ext4"
  }
}

resource "kubernetes_persistent_volume_claim" "nexus_pvc" {
  provider = kubernetes.eks

  metadata {
    name      = "nexus-pvc"
    namespace = kubernetes_namespace.eks_build.metadata[0].name
  }

  spec {
    storage_class_name = kubernetes_storage_class.gp2_immediate.metadata[0].name
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "nexus" {
  provider         = kubernetes.eks
  wait_for_rollout = false

  metadata {
    name      = "nexus-deployment"
    namespace = kubernetes_namespace.eks_build.metadata[0].name
    labels = {
      app = "nexus"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nexus"
      }
    }

    template {
      metadata {
        labels = {
          app = "nexus"
        }
      }

      spec {

        security_context {
          run_as_user  = 200
          run_as_group = 200
          fs_group     = 200
        }

        container {
          name  = "nexus"
          image = "sonatype/nexus3:latest"

          port {
            container_port = 8081
            name           = "nexus-ui"
          }

          port {
            container_port = 8082
            name           = "docker-registry"
          }

          env {
            name  = "NEXUS_SECURITY_RANDOMPASSWORD"
            value = "false"
          }

          env {
            name  = "INSTALL4J_ADD_VM_PARAMS"
            value = "-Xms1g -Xmx2g -XX:MaxDirectMemorySize=3g -Djava.util.prefs.userRoot=/nexus-data/javaprefs"
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "1Gi"
            }
            limits = {
              cpu    = "1"
              memory = "2Gi"
            }
          }

          volume_mount {
            name       = "nexus-data"
            mount_path = "/nexus-data"
          }

          readiness_probe {
            http_get {
              path = "/service/rest/v1/status"
              port = 8081
            }
            initial_delay_seconds = 60
          }

          liveness_probe {
            http_get {
              path = "/service/rest/v1/status"
              port = 8081
            }
            initial_delay_seconds = 180
          }
        }

        volume {
          name = "nexus-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nexus_pvc.metadata[0].name
          }
        }

        node_selector = {
          "kubernetes.io/arch" = "amd64"
        }
      }
    }
  }
}

resource "kubernetes_service" "nexus" {
  provider = kubernetes.eks

  metadata {
    name      = "nexus-service"
    namespace = kubernetes_namespace.eks_build.metadata[0].name
  }

  spec {
    selector = {
      app = "nexus"
    }

    port {
      name        = "nexus-ui"
      port        = 8081
      target_port = 8081
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "nexus_docker_registry" {
  provider = kubernetes.eks

  metadata {
    name      = "nexus-docker-service"
    namespace = kubernetes_namespace.eks_build.metadata[0].name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }

  spec {
    selector = {
      app = "nexus"
    }

    port {
      name        = "docker-registry"
      port        = 8082
      target_port = 8082
    }

    type = "LoadBalancer"
  }
}

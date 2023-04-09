
data "google_client_config" "provider" {}

provider "kubernetes" {
  host = "https://${google_container_cluster.gke.endpoint
  }"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.gke.master_auth.0.cluster_ca_certificate
  )
}



resource "kubernetes_deployment" "nginx" {
  count = 1

  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
    namespace = var.namespace
  }

  wait_for_rollout = true

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:stable"
          name  = "nginx"
          port {
            container_port = 80
          }

          args = ["nginx", "-g", "daemon off;"]

          resources {
            requests = {
              cpu               = "250m"
              ephemeral-storage = "1Gi"
              memory            = "512Mi"
            }
          }
        }
      }
    }
  }
}

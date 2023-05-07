
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
  count = 0

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


resource "kubernetes_service" "service" {
  count = 0
  metadata {
    name = "nginx"
    annotations = {
      "cloud.google.com/app-protocols" : "{\"http\":\"HTTP\"}"
    }

    namespace = var.namespace
  }



  wait_for_load_balancer = false

  spec {
    type             = "LoadBalancer"
    session_affinity = "None"

    port {
      name        = "http"
      protocol    = "TCP"
      port        = "80"
      target_port = "80"
    }

    selector = {
      app = kubernetes_deployment.nginx.0.metadata[0].name
    }
  }
}

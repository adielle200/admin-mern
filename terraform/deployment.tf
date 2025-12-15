# Backend Deployment
resource "kubernetes_deployment" "backend_deployment" {
  metadata {
    name      = "mern-backend"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
    labels = {
      app = "mern-backend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mern-backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "mern-backend"
        }
      }

      spec {
        container {
          name  = "mern-backend"
          image = "mern-backend:16"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          # ⚠️ Probes désactivées (Node version KO)
        }
      }
    }
  }
}


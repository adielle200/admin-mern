# deployment.tf
# Namespace
resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = "mern-app-ns"
  }
}

# Frontend Deployment
resource "kubernetes_deployment" "frontend_deployment" {
  metadata {
    name      = "mern-frontend"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
    labels = {
      app = "mern-frontend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "mern-frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "mern-frontend"
        }
      }

      spec {
        container {
          name  = "mern-frontend"
          image = "mern-frontend:${var.frontend_image_tag}"
          image_pull_policy = "Always"

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

          liveness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }
  }
}

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
    replicas = 2

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
          image = "mern-backend:${var.backend_image_tag}"
          image_pull_policy = "Always"

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

          liveness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }
  }
}

# Frontend Service
resource "kubernetes_service" "frontend_service" {
  metadata {
    name      = "frontend-service"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.frontend_deployment.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

# Backend Service
resource "kubernetes_service" "backend_service" {
  metadata {
    name      = "backend-service"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.backend_deployment.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

# Ingress
resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name      = "mern-ingress"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "mern.local"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.frontend_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}


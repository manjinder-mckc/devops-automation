########################
###### Deployment ######
########################
resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.name_prefix
    namespace = var.namespace
    labels = {
      app = var.name_prefix
    }
  }

  spec {
    replicas = var.deployment_replicas

    selector {
      match_labels = {
        app = var.name_prefix
      }
    }

    template {
      metadata {
        labels = {
          app = var.name_prefix
        }
      }

      spec {
        container {
          name  = var.name_prefix
          image = var.image

          port {
            container_port = 80
          }

          env {
            name  = "APP_ENV"
            value = var.env
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/usr/share/nginx/html/config.html"
            sub_path   = "config.html"
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }

        volume {
          name = "config-volume"

          config_map {
            name = kubernetes_config_map.app_config.metadata[0].name
          }
        }
      }
    }
  }
}

#########################
###### Service ##########
#########################
resource "kubernetes_service" "app" {
  metadata {
    name      = var.name_prefix
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.name_prefix
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

###########################
###### ConfigMap ##########
###########################
resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "${var.name_prefix}-config"
    namespace = var.namespace
  }

  data = {
    "config.html" = file("${path.module}/files/config.html")
  }
}
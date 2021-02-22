terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
provider "kubernetes" {
  config_path = "C:\Users\sushi\.kube"
}
resource "kubernetes_deployment" "flaskapp" {
  metadata {
    name = "scalable-flaskapp-example"
    labels = {
      App = "ScalableFlaskappExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableFlaskappExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableFlaskappExample"
        }
      }
      spec {
        container {
          image = "sushilgautam/final_flask_image:latest"
          name  = "example"
          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "flaskapp" {
  metadata {
    name = "flaskapp-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flaskapp.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30202
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}





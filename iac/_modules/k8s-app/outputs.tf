output "deployment_image" {
  value = kubernetes_deployment.app.spec[0].template[0].spec[0].container[0].image
}
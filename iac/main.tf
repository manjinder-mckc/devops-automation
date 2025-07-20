module "k8s-app-1" {
  source              = "./_modules/k8s-app"
  namespace           = var.namespace
  name_prefix         = var.name_prefix
  image               = var.image
  env                 = var.env
  deployment_replicas = var.deployment_replicas
}
variable "namespace" {
  description = "The Kubernetes namespace where the application will be deployed."
  type        = string
  default     = "msingh"
}

variable "name_prefix" {
  description = "Name of the Kubernetes resources to prefix k8s resources with. "
  type        = string
  default     = "turo-devops-exercise"

}

variable "image" {
  description = "Docker image for the app"
  type        = string
}

variable "env" {
  description = "Deployment Environment for the app"
  type        = string
  default     = "development"

}

variable "deployment_replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 1

}
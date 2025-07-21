# fixtures

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.16.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_test-app-1"></a> [test-app-1](#module\_test-app-1) | ../../../iac/_modules/k8s-app | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image"></a> [image](#input\_image) | Docker image for the app | `string` | n/a | yes |
| <a name="input_deployment_replicas"></a> [deployment\_replicas](#input\_deployment\_replicas) | Number of replicas for the deployment | `number` | `1` | no |
| <a name="input_env"></a> [env](#input\_env) | Deployment Environment for the app | `string` | `"development"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name of the Kubernetes resources to prefix k8s resources with. | `string` | `"turo-devops-exercise"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace where the application will be deployed. | `string` | `"msingh"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_image"></a> [deployment\_image](#output\_deployment\_image) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

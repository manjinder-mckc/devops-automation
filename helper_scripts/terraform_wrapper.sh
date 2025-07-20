#!/bin/bash
# filepath: /Users/Manjinder_Singh/Builds/learning/devops-automation/helper_scripts/terraform_apply.sh

set -e

# Variables
TERRAFORM_DIR="../iac" # Path to the Terraform configuration directory
PLAN_FILE="terraform.plan"

# Functions
usage() {
  echo "Usage: $0 [apply|plan|destroy]"
  echo
  echo "Commands:"
  echo "  plan     Generate and save a Terraform execution plan."
  echo "  apply    Apply the Terraform configuration."
  echo "  destroy  Destroy the Terraform-managed infrastructure."
  exit 1
}

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
  echo "Error: Terraform is not installed. Please install Terraform and try again."
  exit 1
fi

# Ensure the Terraform directory exists
if [ ! -d "$TERRAFORM_DIR" ]; then
  echo "Error: Terraform directory '$TERRAFORM_DIR' does not exist."
  exit 1
fi

# Navigate to the Terraform directory
cd "$TERRAFORM_DIR"

# Parse the command
COMMAND=${1:-}
if [[ -z "$COMMAND" ]]; then
  usage
fi

case "$COMMAND" in
  plan)
    echo "Initializing Terraform..."
    terraform init

    echo "Validating Terraform configuration..."
    terraform validate

    echo "Generating Terraform plan..."
    terraform plan -out="$PLAN_FILE"
    echo "Terraform plan saved to $PLAN_FILE."
    ;;
  apply)
    echo "Applying Terraform configuration..."
    terraform init
    terraform validate
    terraform plan -out="$PLAN_FILE"
    terraform apply "$PLAN_FILE"
    echo "Terraform apply completed successfully."
    ;;
  destroy)
    echo "Destroying Terraform-managed infrastructure..."
    terraform init
    terraform destroy -auto-approve
    echo "Terraform destroy completed successfully."
    ;;
  *)
    echo "Error: Invalid command '$COMMAND'."
    usage
    ;;
esac
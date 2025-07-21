#!/bin/bash

## build and push
cd ./app
version_type=${1:-patch}

./build_and_push.sh $version_type
if [ $? -ne 0 ]; then
  echo "Build and push failed. Exiting."
  exit 1
fi

## Create PR and apply changes with manual approval
cd ../helper_scripts
read -p "Invoke the deployment PR script (../helper_scripts/create_deploy_pr.py)? (yes/no): " CONFIRMATION
if [[ "$CONFIRMATION" == "yes" ]]; then
  echo "Invoking deployment PR script..."
  python3 ./create_deploy_pr.py "$DEPLOY_IMAGE"
else
  echo "Skipping deployment PR script invocation."
fi

## (ease of use from local for now) Manual approval for terraform apply
read -p "Do you want to apply the Terraform changes? (yes/no): " TF_APPLY_CONFIRMATION
if [[ "$TF_APPLY_CONFIRMATION" == "yes" ]]; then
  echo "Applying terraform.."
  ./terraform_wrapper.sh apply
else
  echo "Skipping terraform apply."
fi


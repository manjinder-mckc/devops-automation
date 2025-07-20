#!/bin/bash

export KUBECONFIG="~/.kube/turo-devops-exercise-kubeconfig"

echo "Using kubeconfig: $KUBECONFIG"

# kubectl create ns msingh || true

kubectl get ns msingh || {
  echo "Failed to create or get namespace 'msingh'."
  exit 1
}

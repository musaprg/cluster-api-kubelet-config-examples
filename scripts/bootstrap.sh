#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

kind create cluster --config config/config.yaml

# Enable the experimental Cluster topology feature.
export CLUSTER_TOPOLOGY=true

# Initialize the management cluster
clusterctl init --infrastructure docker

kubectl config use-context kind-capi-management-cluster-kind

kubectl apply -f ./capi-quickstart.yaml

kind get kubeconfig --name capi-quickstart > capi-quickstart.kubeconfig

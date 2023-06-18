#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

if [[ $(kind get clusters) != *"capi-management-cluster"* ]]; then
    kind create cluster --config config/config.yaml
fi

# Enable the experimental Cluster topology feature.
export CLUSTER_TOPOLOGY=true

# Initialize the management cluster
clusterctl init --infrastructure docker

kubectl config use-context kind-capi-management-cluster-kind

echo "Waiting required controllers to be ready..."
kubectl wait pods --all -A -l control-plane=controller-manager --for condition=Ready --timeout 60s

kubectl apply -f clusters/cloudinit
kubectl apply -f clusters/kubeadm-config-template
kubectl apply -f clusters/kubelet-extra-args

echo "Waiting for clusters to be ready..."
kubectl wait clusters --all -A --for condition=Ready --timeout 120s


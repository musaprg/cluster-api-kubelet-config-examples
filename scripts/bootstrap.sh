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

kubectl wait pods --all -A -l control-plane=controller-manager --for condition=Ready --timeout 60s

kubectl apply -f clusters/cloudinit
kubectl apply -f clusters/kubeadm-config-template
kubectl apply -f clusters/kubelet-extra-args

kubectl wait clusters --all -A --for condition=Ready --timeout 30s

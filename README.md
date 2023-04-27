# cluster-api-kubelet-config-examples

<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/kubelet-integration/#kubelet-configuration-patterns>

## Write a Kubelet conf using CloudInit files

Propagating cluster-level configuration to each kubelet

[sample manifests](./clusters/cloudinit)

## Add kubeletExtraArgs in the KubeadmConfigTemplate

Instance-level configuration

[sample manifests](./clusters/kubelet-extra-args)

## Use kubeletconfiguration patch target defined in the KubeadmConfigTemplate

Instance-level configuration

[sample manifests](./clusters/kubeadm-config-template)

> For applying instance-specific configuration over the base KubeletConfiguration you can use the [`KubeletConfiguration` patches](<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/control-plane-flags/#patches>).

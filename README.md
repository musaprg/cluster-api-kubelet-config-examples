# cluster-api-kubelet-config-examples

<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/kubelet-integration/#kubelet-configuration-patterns>

## Write a Kubelet conf using CloudInit files

Propagating cluster-level configuration to each kubelet

[sample manifests](./clusters/cloudinit)

```
$ docker exec -it cloudinit-6zh27-tgx7j cat /etc/kubernetes/kubelet/config.yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
evictionHard:
  nodefs.available: "0%"
  nodefs.inodesFree: "0%"
  imagefs.available: "0%"
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 0s
    enabled: true
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.crt
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 0s
    cacheUnauthorizedTTL: 0s
cgroupDriver: systemd
clusterDNS:
- 10.128.0.10
clusterDomain: cluster.local
containerRuntimeEndpoint: ""
cpuManagerReconcilePeriod: 0s
evictionPressureTransitionPeriod: 0s
fileCheckFrequency: 0s
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 0s
imageMinimumGCAge: 0s
logging:
  flushFrequency: 0
  options:
    json:
      infoBufferSize: "0"
  verbosity: 0
memorySwap: {}
nodeStatusReportFrequency: 0s
nodeStatusUpdateFrequency: 0s
rotateCertificates: true
runtimeRequestTimeout: 0s
shutdownGracePeriod: 0s
shutdownGracePeriodCriticalPods: 0s
staticPodPath: /etc/kubernetes/manifests
streamingConnectionIdleTimeout: 0s
syncFrequency: 0s
volumeStatsAggPeriod: 0s
```

```
$ docker exec -it cloudinit-6zh27-tgx7j cat /var/lib/kubelet/kubeadm-flags.env
KUBELET_KUBEADM_ARGS="--config=/etc/kubernetes/kubelet/config.yaml --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.9"
```

## Add kubeletExtraArgs in the KubeadmConfigTemplate

Instance-level configuration

[sample manifests](./clusters/kubelet-extra-args)

```
$ docker exec -it kubelet-extra-args-8xw46-8zws8 cat /var/lib/kubelet/kubeadm-flags.env
KUBELET_KUBEADM_ARGS="--container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --eviction-hard=nodefs.available<0%,nodefs.inodesFree<0%,imagefs.available<0% --pod-infra-container-image=registry.k8s.io/pause:3.9"
```

## Use kubeletconfiguration patch target defined in the KubeadmConfigTemplate

Instance-level configuration

[sample manifests](./clusters/kubeadm-config-template)

> For applying instance-specific configuration over the base KubeletConfiguration you can use the [`KubeletConfiguration` patches](<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/control-plane-flags/#patches>).

```
$ docker exec -it kubeadm-config-template-xck8g-pf9l8 cat /var/lib/kubelet/config.yaml
apiVersion: kubelet.config.k8s.io/v1beta1
...
evictionHard:
  imagefs.available: 0%
  nodefs.available: 0%
  nodefs.inodesFree: 0%
...
kind: KubeletConfiguration
...
```

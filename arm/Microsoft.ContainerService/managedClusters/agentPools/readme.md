# Managed Cluster AgentPool `[Microsoft.ContainerService/managedClusters/agentPools]`

This module deploys an Agent Pool for a Container Service Managed Cluster

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerService/managedClusters/agentPools` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowedUnsafeSysctls` | array | `[kernel.shm*, kernel.msg*, kernel.sem*, fs.mqueue.*, net.*]` | `[kernel.shm*, kernel.msg*, kernel.sem*, fs.mqueue.*, net.*]` | Optional. Allowed list of unsafe sysctls or unsafe sysctl patterns (ending in *). |
| `availabilityZones` | array | `[]` |  | Optional. The list of Availability zones to use for nodes. This can only be specified if the AgentPoolType property is "VirtualMachineScaleSets".	 |
| `containerLogMaxFiles` | int | `5` |  | Optional. The maximum number of container log files that can be present for a container. The number must be >= 2. |
| `containerLogMaxSizeMB` | int | `10` |  | Optional. The maximum size (e.g. 10 MB) of container log file before it is rotated. |
| `count` | int | `1` |  | Optional. Desired Number of agents (VMs) specified to host docker containers. Allowed values must be in the range of 0 to 1000 (inclusive) for user pools and in the range of 1 to 1000 (inclusive) for system pools. The default value is 1. |
| `cpuCfsQuota` | bool | `True` | `[True, False]` | Optional. Enable/Disable CPU CFS quota enforcement for containers that specify CPU limits. |
| `cpuCfsQuotaPeriod` | string | `100ms` |  | Optional. Sets CPU CFS quota period value. Valid values are a sequence of decimal numbers with an optional fraction and a unit suffix. For example: "300ms", "2h45m". Supported units are "ns", "us", "ms", "s", "m", and "h" . |
| `cpuManagerPolicy` | string | `none` | `[none, static]` | Optional. The static policy allows containers in Guaranteed pods with integer CPU requests access to exclusive CPUs on the node. See Kubernetes CPU management policies for more info (https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#cpu-management-policies) |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `enableAutoScaling` | bool |  | `[True, False]` | Optional. Whether to enable auto-scaler |
| `enableEncryptionAtHost` | bool |  | `[True, False]` | Optional. This is only supported on certain VM sizes and in certain Azure regions. For more information, see: /azure/aks/enable-host-encryption	 |
| `enableFIPS` | bool |  | `[True, False]` | Optional. See Add a FIPS-enabled node pool (https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools#add-a-fips-enabled-node-pool-preview) for more details. |
| `enableNodePublicIP` | bool |  | `[True, False]` | Optional. Some scenarios may require nodes in a node pool to receive their own dedicated public IP addresses. A common scenario is for gaming workloads, where a console needs to make a direct connection to a cloud virtual machine to minimize hops. For more information see assigning a public IP per node (https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools#assign-a-public-ip-per-node-for-your-node-pools). The default is false. |
| `enableUltraSSD` | bool |  | `[True, False]` | Optional. Whether to enable UltraSSD |
| `failSwapOn` | bool |  | `[True, False]` | Optional. If set to true it will make the Kubelet fail to start if swap is enabled on the node. |
| `fsAioMaxNr` | int | `65536` |  | Optional. Sysctl setting fs.aio-max-nr. |
| `fsFileMax` | int | `8192` |  | Optional. Sysctl setting fs.file-max. |
| `fsInotifyMaxUserWatches` | int | `781250` |  | Optional. Sysctl setting fs.inotify.max_user_watches. |
| `fsNrOpen` | int | `8192` |  | Optional. Sysctl setting fs.nr_open. |
| `gpuInstanceProfile` | string |  | `[MIG1g, MIG2g, MIG3g, MIG4g, MIG7g, ]` | Optional. GPUInstanceProfile to be used to specify GPU MIG instance profile for supported GPU VM SKU. |
| `imageGcHighThreshold` | int | `85` |  | Optional. The percent of disk usage after which image garbage collection is always run. Minimum disk usage that will trigger garbage collection. To disable image garbage collection, set to 100. |
| `imageGcLowThreshold` | int | `80` |  | Optional. The percent of disk usage before which image garbage collection is never run. Minimum disk usage that can trigger garbage collection. |
| `kernelThreadsMax` | int | `20` |  | Optional. Sysctl setting kernel.threads-max. |
| `kubeletDiskType` | string |  |  | Optional. Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage. |
| `managedClusterName` | string |  |  | Required. Name of the managed cluster |
| `maxCount` | int | `-1` |  | Optional. The maximum number of nodes for auto-scaling |
| `maxPods` | int | `-1` |  | Optional. The maximum number of pods that can run on a node. |
| `maxSurge` | string |  |  | Optional. This can either be set to an integer (e.g. "5") or a percentage (e.g. "50%"). If a percentage is specified, it is the percentage of the total agent pool size at the time of the upgrade. For percentages, fractional nodes are rounded up. If not specified, the default is 1. For more information, including best practices, see: /azure/aks/upgrade-cluster#customize-node-surge-upgrade |
| `minCount` | int | `-1` |  | Optional. The minimum number of nodes for auto-scaling |
| `mode` | string |  |  | Optional. A cluster must have at least one "System" Agent Pool at all times. For additional information on agent pool restrictions and best practices, see: /azure/aks/use-system-pools |
| `name` | string |  |  | Required. Name of the agent pool |
| `netCoreNetdevMaxBacklog` | int | `1000` |  | Optional. Sysctl setting net.core.netdev_max_backlog. |
| `netCoreOptmemMax` | int | `20480` |  | Optional. Sysctl setting net.core.optmem_max. |
| `netCoreRmemDefault` | int | `212992` |  | Optional. Sysctl setting net.core.rmem_default. |
| `netCoreRmemMax` | int | `212992` |  | Optional. Sysctl setting net.core.rmem_max. |
| `netCoreSomaxconn` | int | `4096` |  | Optional. Sysctl setting net.core.somaxconn. |
| `netCoreWmemDefault` | int | `212992` |  | Optional. Sysctl setting net.core.wmem_default. |
| `netCoreWmemMax` | int | `212992` |  | Optional. Sysctl setting net.core.wmem_max. |
| `netIpv4IpLocalPortRange` | string |  |  | Optional. Sysctl setting net.ipv4.ip_local_port_range. |
| `netIpv4NeighDefaultGcThresh1` | int | `128` |  | Optional. Sysctl setting net.ipv4.neigh.default.gc_thresh1. |
| `netIpv4NeighDefaultGcThresh2` | int | `512` |  | Optional. Sysctl setting net.ipv4.neigh.default.gc_thresh2. |
| `netIpv4NeighDefaultGcThresh3` | int | `1024` |  | Optional. Sysctl setting net.ipv4.neigh.default.gc_thresh3. |
| `netIpv4TcpFinTimeout` | int | `5` |  | Optional. Sysctl setting net.ipv4.tcp_fin_timeout. |
| `netIpv4TcpkeepaliveIntvl` | int | `10` |  | Optional. Sysctl setting net.ipv4.tcp_keepalive_intvl. |
| `netIpv4TcpKeepaliveProbes` | int | `1` |  | Optional. Sysctl setting net.ipv4.tcp_keepalive_probes. |
| `netIpv4TcpKeepaliveTime` | int | `30` |  | Optional. Sysctl setting net.ipv4.tcp_keepalive_time. |
| `netIpv4TcpMaxSynBacklog` | int | `128` |  | Optional. Sysctl setting net.ipv4.tcp_max_syn_backlog |
| `netIpv4TcpMaxTwBuckets` | int | `8000` |  | Optional. Sysctl setting net.ipv4.tcp_max_tw_buckets. |
| `netIpv4TcpTwReuse` | bool |  | `[True, False]` | Optional. Sysctl setting net.ipv4.tcp_tw_reuse. |
| `netNetfilterNfConntrackBuckets` | int | `65536` |  | Optional. Sysctl setting net.netfilter.nf_conntrack_buckets. |
| `netNetfilterNfConntrackMax` | int | `131072` |  | Optional. Sysctl setting net.netfilter.nf_conntrack_max. |
| `nodeLabels` | object | `{object}` |  | Optional. The node labels to be persisted across all nodes in agent pool. |
| `nodePublicIpPrefixId` | string |  |  | Optional. ResourceId of the node PublicIPPrefix |
| `nodeTaints` | array | `[]` |  | Optional. The taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule.	 |
| `orchestratorVersion` | string |  |  | Optional. As a best practice, you should upgrade all node pools in an AKS cluster to the same Kubernetes version. The node pool version must have the same major version as the control plane. The node pool minor version must be within two minor versions of the control plane version. The node pool version cannot be greater than the control plane version. For more information see upgrading a node pool (https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools#upgrade-a-node-pool). |
| `osDiskSizeGB` | int |  |  | Optional. OS Disk Size in GB to be used to specify the disk size for every machine in the master/agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified. |
| `osDiskType` | string |  | `[Ephemeral, Managed, ]` | Optional. The default is "Ephemeral" if the VM supports it and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to "Managed". May not be changed after creation. For more information see Ephemeral OS (https://docs.microsoft.com/en-us/azure/aks/cluster-configuration#ephemeral-os). |
| `osSku` | string |  | `[CBLMariner, Ubuntu, ]` | Optional. Specifies an OS SKU. This value must not be specified if OSType is Windows. |
| `osType` | string | `Linux` | `[Linux, Windows]` | Optional. The operating system type. The default is Linux. |
| `podMaxPids` | int | `-1` |  | Optional. The maximum number of processes per pod. |
| `podSubnetId` | string |  |  | Optional. Subnet ID for the pod IPs. If omitted, pod IPs are statically assigned on the node subnet (see vnetSubnetID for more details). This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}	 |
| `proximityPlacementGroupId` | string |  |  | Optional. The ID for the Proximity Placement Group. |
| `scaleDownMode` | string | `Delete` | `[Deallocate, Delete]` | Optional. Describes how VMs are added to or removed from Agent Pools. See billing states (https://docs.microsoft.com/en-us/azure/virtual-machines/states-billing). |
| `scaleSetEvictionPolicy` | string | `Delete` | `[Deallocate, Delete]` | Optional. The eviction policy specifies what to do with the VM when it is evicted. The default is Delete. For more information about eviction see spot VMs	 |
| `scaleSetPriority` | string |  | `[Regular, Spot, ]` | Optional. The Virtual Machine Scale Set priority. |
| `sourceResourceId` | string |  |  | Optional. This is the ARM ID of the source object to be used to create the target object. |
| `spotMaxPrice` | int | `-1` |  | Optional. Possible values are any decimal value greater than zero or -1 which indicates the willingness to pay any on-demand price. For more details on spot pricing, see spot VMs pricing (https://docs.microsoft.com/en-us/azure/virtual-machines/spot-vms#pricing) |
| `swapFileSizeMB` | int | `1500` |  | Optional. The size in MB of a swap file that will be created on each node. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `topologyManagerPolicy` | string | `none` | `[none, best-effort, restricted, single-numa-node]` | Optional. Optimize NUMA node alignment. For more information see Kubernetes Topology Manager (https://kubernetes.io/docs/tasks/administer-cluster/topology-manager) |
| `transparentHugePageDefrag` | string | `madvise` | `[always, defer, defer+madvise, madvise, never]` | Optional. See Transparent Hugepages (https://www.kernel.org/doc/html/latest/admin-guide/mm/transhuge.html#admin-guide-transhuge) |
| `transparentHugePageEnabled` | string | `always` | `[always, madvise, never]` | Optional. See Transparent Hugepages (https://www.kernel.org/doc/html/latest/admin-guide/mm/transhuge.html#admin-guide-transhuge) |
| `type` | string |  |  | Optional. The type of Agent Pool. |
| `vmMaxMapCount` | int | `65530` |  | Optional. Sysctl setting vm.max_map_count. |
| `vmSize` | string | `Standard_D2s_v3` |  | Optional. VM size. VM size availability varies by region. If a node contains insufficient compute resources (memory, cpu, etc) pods might fail to run correctly. For more details on restricted VM sizes, see: /azure/aks/quotas-skus-regions |
| `vmSwappiness` | int |  |  | Optional. Sysctl setting vm.swappiness. |
| `vmVfsCachePressure` | int |  |  | Optional. Sysctl setting vm.vfs_cache_pressure. |
| `vnetSubnetId` | string |  |  | Optional. Node Subnet ID. If this is not specified, a VNET and subnet will be generated and used. If no podSubnetID is specified, this applies to nodes and pods, otherwise it applies to just nodes. This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}	 |
| `workloadRuntime` | string |  |  | Optional. Determines the type of workload a node can run. |

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `agentPoolName` | string | The name of the agent pool |
| `agentPoolResourceGroup` | string | The resource group the agent pool was deployed into. |
| `agentPoolResourceId` | string | The resource ID of the agent pool |

## Template references

- [Managedclusters/Agentpools](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2021-08-01/managedClusters/agentPools)

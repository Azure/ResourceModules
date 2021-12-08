@description('Required. Name of the managed cluster')
@minLength(1)
param managedClusterName string

@description('Required. Name of the agent pool')
param name string

@description('Optional. The list of Availability zones to use for nodes. This can only be specified if the AgentPoolType property is "VirtualMachineScaleSets".	')
param availabilityZones array = []

@description('Optional. Desired Number of agents (VMs) specified to host docker containers. Allowed values must be in the range of 0 to 1000 (inclusive) for user pools and in the range of 1 to 1000 (inclusive) for system pools. The default value is 1.')
@minValue(0)
@maxValue(1000)
param count int = 1

@description('Optional. This is the ARM ID of the source object to be used to create the target object.')
param sourceResourceId string

@description('Optional. Whether to enable auto-scaler')
@allowed([
  true
  false
])
param enableAutoScaling bool = false

@description('Optional. This is only supported on certain VM sizes and in certain Azure regions. For more information, see: /azure/aks/enable-host-encryption	')
@allowed([
  true
  false
])
param enableEncryptionAtHost bool = false

@description('Optional. See Add a FIPS-enabled node pool (https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools#add-a-fips-enabled-node-pool-preview) for more details.')
@allowed([
  true
  false
])
param enableFIPS bool = false

@description('Optional. Some scenarios may require nodes in a node pool to receive their own dedicated public IP addresses. A common scenario is for gaming workloads, where a console needs to make a direct connection to a cloud virtual machine to minimize hops. For more information see assigning a public IP per node (https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools#assign-a-public-ip-per-node-for-your-node-pools). The default is false.')
@allowed([
  true
  false
])
param enableNodePublicIP bool = false

@description('Optional. Whether to enable UltraSSD')
@allowed([
  true
  false
])
param enableUltraSSD bool = false

@description('Optional. GPUInstanceProfile to be used to specify GPU MIG instance profile for supported GPU VM SKU.')
@allowed([
  'MIG1g'
  'MIG2g'
  'MIG3g'
  'MIG4g'
  'MIG7g'
])
param gpuInstanceProfile string = 'MIG1g'

@description('Optional. Allowed list of unsafe sysctls or unsafe sysctl patterns (ending in *).')
@allowed([
  'kernel.shm*'
  'kernel.msg*'
  'kernel.sem*'
  'fs.mqueue.*'
  'net.*'
])
param allowedUnsafeSysctls array = [
  'kernel.shm*'
  'kernel.msg*'
  'kernel.sem*'
  'fs.mqueue.*'
  'net.*'
]

@description('Optional. The maximum number of container log files that can be present for a container. The number must be ≥ 2.')
@minValue(2)
param containerLogMaxFiles int = 5

@description('Optional. The maximum size (e.g. 10 MB) of container log file before it is rotated.')
param containerLogMaxSizeMB int = 10

@description('Optional. Enable/Disable CPU CFS quota enforcement for containers that specify CPU limits.')
@allowed([
  true
  false
])
param cpuCfsQuota bool = true

@description('Optional. Sets CPU CFS quota period value. Valid values are a sequence of decimal numbers with an optional fraction and a unit suffix. For example: "300ms", "2h45m". Supported units are "ns", "us", "ms", "s", "m", and "h" .')
param cpuCfsQuotaPeriod string = '100ms'

@description('Optional. The static policy allows containers in Guaranteed pods with integer CPU requests access to exclusive CPUs on the node. See Kubernetes CPU management policies for more info (https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#cpu-management-policies)')
@allowed([
  'none'
  'static'
])
param cpuManagerPolicy string = 'none'

@description('Optional. If set to true it will make the Kubelet fail to start if swap is enabled on the node.')
@allowed([
  true
  false
])
param failSwapOn bool = false

@description('Optional. The percent of disk usage after which image garbage collection is always run. Minimum disk usage that will trigger garbage collection. To disable image garbage collection, set to 100.')
@minValue(0)
@maxValue(100)
param imageGcHighThreshold int = 85

@description('Optional. The percent of disk usage before which image garbage collection is never run. Minimum disk usage that can trigger garbage collection.')
@minValue(0)
@maxValue(100)
param imageGcLowThreshold int = 80

@description('Optional. The maximum number of processes per pod.')
@minValue(-1)
param podMaxPids int = -1

@description('Optional. Optimize NUMA node alignment. For more information see Kubernetes Topology Manager (https://kubernetes.io/docs/tasks/administer-cluster/topology-manager)')
@allowed([
  'none'
  'best-effort'
  'restricted'
  'single-numa-node'
])
param topologyManagerPolicy string = 'none'

@description('Optional. Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage.')
param kubeletDiskType string = ''

@description('Optional. The size in MB of a swap file that will be created on each node.')
param swapFileSizeMB int = -1

@description('Optional. Sysctl setting fs.aio-max-nr.')
param fsAioMaxNr int = -1

@description('Optional. Sysctl setting fs.file-max.')
param fsFileMax int = -1

@description('Optional. Sysctl setting fs.inotify.max_user_watches.')
param fsInotifyMaxUserWatches int = -1

@description('Optional. Sysctl setting fs.nr_open.')
param fsNrOpen int = -1

@description('Optional. Sysctl setting kernel.threads-max.')
param kernelThreadsMax int = -1

@description('Optional. Sysctl setting net.core.netdev_max_backlog.')
param netCoreNetdevMaxBacklog int = -1

@description('Optional. Sysctl setting net.core.optmem_max.')
param netCoreOptmemMax int = -1

@description('Optional. Sysctl setting net.core.rmem_default.')
param netCoreRmemDefault int = -1

@description('Optional. Sysctl setting net.core.rmem_max.')
param netCoreRmemMax int = -1

@description('Optional. Sysctl setting net.core.somaxconn.')
param netCoreSomaxconn int = -1

@description('Optional. Sysctl setting net.core.wmem_default.')
param netCoreWmemDefault int = -1

@description('Optional. Sysctl setting net.core.wmem_max.')
param netCoreWmemMax int = -1

@description('Optional. Sysctl setting net.ipv4.ip_local_port_range.')
param netIpv4IpLocalPortRange string = ''

@description('Optional. Sysctl setting net.ipv4.neigh.default.gc_thresh1.')
param netIpv4NeighDefaultGcThresh1 int = -1

@description('Optional. Sysctl setting net.ipv4.neigh.default.gc_thresh2.')
param netIpv4NeighDefaultGcThresh2 int = -1

@description('Optional. Sysctl setting net.ipv4.neigh.default.gc_thresh3.')
param netIpv4NeighDefaultGcThresh3 int = -1

@description('Optional. Sysctl setting net.ipv4.tcp_fin_timeout.')
param netIpv4TcpFinTimeout int = -1

@description('Optional. Sysctl setting net.ipv4.tcp_keepalive_intvl.')
param netIpv4TcpkeepaliveIntvl int = -1

@description('Optional. Sysctl setting net.ipv4.tcp_keepalive_probes.')
param netIpv4TcpKeepaliveProbes int = -1

@description('Optional. Sysctl setting net.ipv4.tcp_keepalive_time.')
param netIpv4TcpKeepaliveTime int = -1

@description('Optional. Sysctl setting net.ipv4.tcp_max_syn_backlog')
param netIpv4TcpMaxSynBacklog int = -1

@description('Optional. Sysctl setting net.ipv4.tcp_max_tw_buckets.')
param netIpv4TcpMaxTwBuckets int = -1

@description('Optional. Sysctl setting net.ipv4.tcp_tw_reuse.')
@allowed([
  true
  false
])
param netIpv4TcpTwReuse bool = false

@description('Optional. Sysctl setting net.netfilter.nf_conntrack_buckets.')
param netNetfilterNfConntrackBuckets int = -1

@description('Optional. Sysctl setting net.netfilter.nf_conntrack_max.')
param netNetfilterNfConntrackMax int = -1

@description('Optional. Sysctl setting vm.max_map_count.')
param vmMaxMapCount int = -1

@description('Optional. Sysctl setting vm.swappiness.')
param vmSwappiness int = -1

@description('Optional. Sysctl setting vm.vfs_cache_pressure.')
param vmVfsCachePressure int = -1

@description('Optional. See Transparent Hugepages (https://www.kernel.org/doc/html/latest/admin-guide/mm/transhuge.html#admin-guide-transhuge)')
@allowed([
  'always'
  'defer'
  'defer+madvise'
  'madvise'
  'never'
])
param transparentHugePageDefrag string = 'madvise'

@description('Optional. See Transparent Hugepages (https://www.kernel.org/doc/html/latest/admin-guide/mm/transhuge.html#admin-guide-transhuge)')
@allowed([
  'always'
  'madvise'
  'never'
])
param transparentHugePageEnabled string = 'always'

@description('Optional. The maximum number of nodes for auto-scaling')
param maxCount int = -1

@description('Optional. The maximum number of pods that can run on a node.')
param maxPods int = -1

@description('Optional. The minimum number of nodes for auto-scaling')
param minCount int = -1

@description('Optional. A cluster must have at least one "System" Agent Pool at all times. For additional information on agent pool restrictions and best practices, see: /azure/aks/use-system-pools')
param mode string = ''

@description('Optional. The node labels to be persisted across all nodes in agent pool.')
param nodeLabels object = {}

@description('Optional. ResourceId of the node PublicIPPrefix')
param nodePublicIpPrefixId string = ''

@description('Optional. The taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule.	')
param nodeTaints array = []

@description('Optional. 	As a best practice, you should upgrade all node pools in an AKS cluster to the same Kubernetes version. The node pool version must have the same major version as the control plane. The node pool minor version must be within two minor versions of the control plane version. The node pool version cannot be greater than the control plane version. For more information see upgrading a node pool (https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools#upgrade-a-node-pool).')
param orchestratorVersion string = ''

@description('Optional. OS Disk Size in GB to be used to specify the disk size for every machine in the master/agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified.')
param osDiskSizeGB int = 0

@description('Optional. The default is "Ephemeral" if the VM supports it and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to "Managed". May not be changed after creation. For more information see Ephemeral OS (https://docs.microsoft.com/en-us/azure/aks/cluster-configuration#ephemeral-os).')
@allowed([
  'Ephemeral'
  'Managed'
])
param osDiskType string = 'Ephemeral'

@description('Optional. Specifies an OS SKU. This value must not be specified if OSType is Windows.')
@allowed([
  'CBLMariner'
  'Ubuntu'
  ''
])
param osSku string = ''

@description('Optional. The operating system type. The default is Linux.')
@allowed([
  'Linux'
  'Windows'
])
param osType string = 'Linux'

@description('Optional. Subnet ID for the pod IPs. If omitted, pod IPs are statically assigned on the node subnet (see vnetSubnetID for more details). This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}	')
param podSubnetId string = ''

@description('Optional. The ID for the Proximity Placement Group.')
param proximityPlacementGroupId string = ''

@description('Optional. Describes how VMs are added to or removed from Agent Pools. See billing states (https://docs.microsoft.com/en-us/azure/virtual-machines/states-billing).')
@allowed([
  'Deallocate'
  'Delete'
])
param scaleDownMode string = 'Delete'

@description('Optional. The eviction policy specifies what to do with the VM when it is evicted. The default is Delete. For more information about eviction see spot VMs	')
@allowed([
  'Deallocate'
  'Delete'
])
param scaleSetEvictionPolicy string = 'Delete'

@description('Optional. The Virtual Machine Scale Set priority.')
@allowed([
  'Regular'
  'Spot'
  ''
])
param scaleSetPriority string = ''

@description('Optional. Possible values are any decimal value greater than zero or -1 which indicates the willingness to pay any on-demand price. For more details on spot pricing, see spot VMs pricing (https://docs.microsoft.com/en-us/azure/virtual-machines/spot-vms#pricing)')
param spotMaxPrice int = -1

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The type of Agent Pool.')
param type string = ''

@description('Optional. This can either be set to an integer (e.g. "5") or a percentage (e.g. "50%"). If a percentage is specified, it is the percentage of the total agent pool size at the time of the upgrade. For percentages, fractional nodes are rounded up. If not specified, the default is 1. For more information, including best practices, see: /azure/aks/upgrade-cluster#customize-node-surge-upgrade')
param maxSurge string = ''

@description('Optional. VM size. VM size availability varies by region. If a node contains insufficient compute resources (memory, cpu, etc) pods might fail to run correctly. For more details on restricted VM sizes, see: /azure/aks/quotas-skus-regions')
param vmSize string = 'Standard_D2s_v3'

@description('Optional. Node Subnet IDIf this is not specified, a VNET and subnet will be generated and used. If no podSubnetID is specified, this applies to nodes and pods, otherwise it applies to just nodes. This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}	')
param vnetSubnetId string = ''

@description('Optional. Determines the type of workload a node can run.')
param workloadRuntime string = ''

resource managedCluster 'Microsoft.ContainerService/managedClusters@2021-08-01' existing = {
  name: managedClusterName
}

var creationData = {
  sourceResourceId: sourceResourceId
}

var kubeletConfig = {
  allowedUnsafeSysctls: allowedUnsafeSysctls
  containerLogMaxFiles: containerLogMaxFiles
  containerLogMaxSizeMB: containerLogMaxSizeMB
  cpuCfsQuota: cpuCfsQuota
  cpuCfsQuotaPeriod: cpuCfsQuotaPeriod
  cpuManagerPolicy: cpuManagerPolicy
  failSwapOn: failSwapOn
  imageGcHighThreshold: imageGcHighThreshold
  imageGcLowThreshold: imageGcLowThreshold
  podMaxPids: podMaxPids
  topologyManagerPolicy: topologyManagerPolicy
}

var sysctls = {
  fsAioMaxNr: fsAioMaxNr
  fsFileMax: fsFileMax
  fsInotifyMaxUserWatches: fsInotifyMaxUserWatches
  fsNrOpen: fsNrOpen
  kernelThreadsMax: kernelThreadsMax
  netCoreNetdevMaxBacklog: netCoreNetdevMaxBacklog
  netCoreOptmemMax: netCoreOptmemMax
  netCoreRmemDefault: netCoreRmemDefault
  netCoreRmemMax: netCoreRmemMax
  netCoreSomaxconn: netCoreSomaxconn
  netCoreWmemDefault: netCoreWmemDefault
  netCoreWmemMax: netCoreWmemMax
  netIpv4IpLocalPortRange: netIpv4IpLocalPortRange
  netIpv4NeighDefaultGcThresh1: netIpv4NeighDefaultGcThresh1
  netIpv4NeighDefaultGcThresh2: netIpv4NeighDefaultGcThresh2
  netIpv4NeighDefaultGcThresh3: netIpv4NeighDefaultGcThresh3
  netIpv4TcpFinTimeout: netIpv4TcpFinTimeout
  netIpv4TcpkeepaliveIntvl: netIpv4TcpkeepaliveIntvl
  netIpv4TcpKeepaliveProbes: netIpv4TcpKeepaliveProbes
  netIpv4TcpKeepaliveTime: netIpv4TcpKeepaliveTime
  netIpv4TcpMaxSynBacklog: netIpv4TcpMaxSynBacklog
  netIpv4TcpMaxTwBuckets: netIpv4TcpMaxTwBuckets
  netIpv4TcpTwReuse: netIpv4TcpTwReuse
  netNetfilterNfConntrackBuckets: netNetfilterNfConntrackBuckets
  netNetfilterNfConntrackMax: netNetfilterNfConntrackMax
  vmMaxMapCount: vmMaxMapCount
  vmSwappiness: vmSwappiness
  vmVfsCachePressure: vmVfsCachePressure
}

var linuxOSConfig = {
  swapFileSizeMB: swapFileSizeMB
  sysctls: sysctls
  transparentHugePageDefrag: transparentHugePageDefrag
  transparentHugePageEnabled: transparentHugePageEnabled
}

var upgradeSettings = {
  maxSurge: maxSurge
}

resource agentPool 'Microsoft.ContainerService/managedClusters/agentPools@2021-08-01' = {
  name: name
  parent: managedCluster
  properties: {
    availabilityZones: availabilityZones
    count: count
    //creationData: creationData
    enableAutoScaling: enableAutoScaling
    enableEncryptionAtHost: enableEncryptionAtHost
    enableFIPS: enableFIPS
    enableNodePublicIP: enableNodePublicIP
    enableUltraSSD: enableUltraSSD
    gpuInstanceProfile: gpuInstanceProfile
    kubeletConfig: kubeletConfig
    kubeletDiskType: kubeletDiskType
    linuxOSConfig: linuxOSConfig
    maxCount: !(maxCount == -1) ? maxCount : null
    maxPods: !(maxPods == -1) ? maxPods : null
    minCount: !(minCount == -1) ? minCount : null
    mode: !empty(mode) ? mode : null
    nodeLabels: nodeLabels
    nodePublicIPPrefixID: !empty(nodePublicIpPrefixId) ? nodePublicIpPrefixId : null
    nodeTaints: nodeTaints
    orchestratorVersion: orchestratorVersion
    osDiskSizeGB: !(osDiskSizeGB == -1) ? osDiskSizeGB : null
    osDiskType: osDiskType
    osSKU: !empty(osSku) ? osSku : null
    osType: osType
    podSubnetID: !empty(podSubnetId) ? podSubnetId : null
    proximityPlacementGroupID: !empty(proximityPlacementGroupId) ? proximityPlacementGroupId : null
    scaleDownMode: scaleDownMode
    scaleSetEvictionPolicy: scaleSetEvictionPolicy
    scaleSetPriority: !empty(scaleSetPriority) ? scaleSetPriority : null
    spotMaxPrice: spotMaxPrice
    tags: tags
    type: type
    upgradeSettings: upgradeSettings
    vmSize: vmSize
    vnetSubnetID: vnetSubnetId
    workloadRuntime: workloadRuntime
  }
}

@description('The name of the agent pool')
output agentPoolName string = agentPool.name

@description('The resource ID of the agent pool')
output agentPoolResourceId string = agentPool.id

@description('The resource group the agent pool was deployed into.')
output agentPoolResourceGroup string = resourceGroup().name

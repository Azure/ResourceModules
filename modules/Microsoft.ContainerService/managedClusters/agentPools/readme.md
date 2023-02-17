# Managed Cluster AgentPool `[Microsoft.ContainerService/managedClusters/agentPools]`

This module deploys an Agent Pool for a Container Service Managed Cluster

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerService/managedClusters/agentPools` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2022-09-01/managedClusters/agentPools) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the agent pool. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `managedClusterName` | string | The name of the parent managed cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `availabilityZones` | array | `[]` |  | The list of Availability zones to use for nodes. This can only be specified if the AgentPoolType property is "VirtualMachineScaleSets". |
| `count` | int | `1` |  | Desired Number of agents (VMs) specified to host docker containers. Allowed values must be in the range of 0 to 1000 (inclusive) for user pools and in the range of 1 to 1000 (inclusive) for system pools. The default value is 1. |
| `enableAutoScaling` | bool | `False` |  | Whether to enable auto-scaler. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableEncryptionAtHost` | bool | `False` |  | This is only supported on certain VM sizes and in certain Azure regions. For more information, see: /azure/aks/enable-host-encryption. For security reasons, this setting should be enabled. |
| `enableFIPS` | bool | `False` |  | See Add a FIPS-enabled node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#add-a-fips-enabled-node-pool-preview) for more details. |
| `enableNodePublicIP` | bool | `False` |  | Some scenarios may require nodes in a node pool to receive their own dedicated public IP addresses. A common scenario is for gaming workloads, where a console needs to make a direct connection to a cloud virtual machine to minimize hops. For more information see assigning a public IP per node (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#assign-a-public-ip-per-node-for-your-node-pools). |
| `enableUltraSSD` | bool | `False` |  | Whether to enable UltraSSD. |
| `gpuInstanceProfile` | string | `''` | `['', MIG1g, MIG2g, MIG3g, MIG4g, MIG7g]` | GPUInstanceProfile to be used to specify GPU MIG instance profile for supported GPU VM SKU. |
| `kubeletDiskType` | string | `''` |  | Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage. |
| `maxCount` | int | `-1` |  | The maximum number of nodes for auto-scaling. |
| `maxPods` | int | `-1` |  | The maximum number of pods that can run on a node. |
| `maxSurge` | string | `''` |  | This can either be set to an integer (e.g. "5") or a percentage (e.g. "50%"). If a percentage is specified, it is the percentage of the total agent pool size at the time of the upgrade. For percentages, fractional nodes are rounded up. If not specified, the default is 1. For more information, including best practices, see: /azure/aks/upgrade-cluster#customize-node-surge-upgrade. |
| `minCount` | int | `-1` |  | The minimum number of nodes for auto-scaling. |
| `mode` | string | `''` |  | A cluster must have at least one "System" Agent Pool at all times. For additional information on agent pool restrictions and best practices, see: /azure/aks/use-system-pools. |
| `nodeLabels` | object | `{object}` |  | The node labels to be persisted across all nodes in agent pool. |
| `nodePublicIpPrefixId` | string | `''` |  | ResourceId of the node PublicIPPrefix. |
| `nodeTaints` | array | `[]` |  | The taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule. |
| `orchestratorVersion` | string | `''` |  | As a best practice, you should upgrade all node pools in an AKS cluster to the same Kubernetes version. The node pool version must have the same major version as the control plane. The node pool minor version must be within two minor versions of the control plane version. The node pool version cannot be greater than the control plane version. For more information see upgrading a node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#upgrade-a-node-pool). |
| `osDiskSizeGB` | int | `0` |  | OS Disk Size in GB to be used to specify the disk size for every machine in the master/agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified. |
| `osDiskType` | string | `''` | `['', Ephemeral, Managed]` | The default is "Ephemeral" if the VM supports it and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to "Managed". May not be changed after creation. For more information see Ephemeral OS (https://learn.microsoft.com/en-us/azure/aks/cluster-configuration#ephemeral-os). |
| `osSku` | string | `''` | `['', CBLMariner, Ubuntu]` | Specifies an OS SKU. This value must not be specified if OSType is Windows. |
| `osType` | string | `'Linux'` | `[Linux, Windows]` | The operating system type. The default is Linux. |
| `podSubnetId` | string | `''` |  | Subnet ID for the pod IPs. If omitted, pod IPs are statically assigned on the node subnet (see vnetSubnetID for more details). This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}. |
| `proximityPlacementGroupId` | string | `''` |  | The ID for the Proximity Placement Group. |
| `scaleDownMode` | string | `'Delete'` | `[Deallocate, Delete]` | Describes how VMs are added to or removed from Agent Pools. See billing states (https://learn.microsoft.com/en-us/azure/virtual-machines/states-billing). |
| `scaleSetEvictionPolicy` | string | `'Delete'` | `[Deallocate, Delete]` | The eviction policy specifies what to do with the VM when it is evicted. The default is Delete. For more information about eviction see spot VMs. |
| `scaleSetPriority` | string | `''` | `['', Regular, Spot]` | The Virtual Machine Scale Set priority. |
| `sourceResourceId` | string | `''` |  | This is the ARM ID of the source object to be used to create the target object. |
| `spotMaxPrice` | int | `-1` |  | Possible values are any decimal value greater than zero or -1 which indicates the willingness to pay any on-demand price. For more details on spot pricing, see spot VMs pricing (https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms#pricing). |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `type` | string | `''` |  | The type of Agent Pool. |
| `vmSize` | string | `'Standard_D2s_v3'` |  | VM size. VM size availability varies by region. If a node contains insufficient compute resources (memory, cpu, etc) pods might fail to run correctly. For more details on restricted VM sizes, see: /azure/aks/quotas-skus-regions. |
| `vnetSubnetId` | string | `''` |  | Node Subnet ID. If this is not specified, a VNET and subnet will be generated and used. If no podSubnetID is specified, this applies to nodes and pods, otherwise it applies to just nodes. This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}. |
| `workloadRuntime` | string | `''` |  | Determines the type of workload a node can run. |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the agent pool. |
| `resourceGroupName` | string | The resource group the agent pool was deployed into. |
| `resourceId` | string | The resource ID of the agent pool. |

## Cross-referenced modules

_None_

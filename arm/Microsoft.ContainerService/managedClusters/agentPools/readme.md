# ContainerServiceManagedClustersAgentPools `[Microsoft.ContainerService/managedClusters/agentPools]`

This module deploys an Agent Pool for a Container Service Managed Cluster

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerService/managedClusters/agentPools` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `managedClusterName` | string |  |  | Required. Name of the managed cluster |
| `name` | string |  |  | Required. The name of the agent pool |
| `agentPoolProperties` | object | `{}` | Complex structure, see below. | Required. Properties for the container service agent pool profile |

### Parameter Usage: `agentPoolProperties`

This object contains the configuration for the agent pool profile. The following example shows an agent pool profile configuration.
For available properties check <https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters/agentpools?tabs=bicep#managedclusteragentpoolprofileproperties-object>

```json
"agentPoolProperties": {
  "value": {
            "vmSize": "Standard_DS3_v2",
            "osDiskSizeGB": 128,
            "count": 2,
            "osType": "Linux",
            "maxCount": 5,
            "minCount": 1,
            "enableAutoScaling": true,
            "scaleSetPriority": "Regular",
            "scaleSetEvictionPolicy": "Delete",
            "nodeLabels": {},
            "nodeTaints": [
                "CriticalAddonsOnly=true:NoSchedule"
            ],
            "type": "VirtualMachineScaleSets",
            "availabilityZones": [
                "1",
                "2",
                "3"
            ],
            "maxPods": 30,
            "storageProfile": "ManagedDisks",
            "mode": "System",
            "vnetSubnetID": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/myRg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet",
            "tags": {
                "Owner": "abc.def@contoso.com",
                "BusinessUnit": "IaCs",
                "Environment": "PROD",
                "Region": "USEast"
            }
        }
    }
```

## Outputs

| Output Name | Type |
| :-- | :-- |
| `agentPoolName` | string |
| `agentPoolId` | string |
| `agentPoolResourceGroup` | string |

## Template references

- [managedClusters/agentPools](https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/2021-05-01/managedclusters/agentpools?tabs=bicep)

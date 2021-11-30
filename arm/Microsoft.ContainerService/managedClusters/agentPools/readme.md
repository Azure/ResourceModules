# Managed Cluster AgentPool `[Microsoft.ContainerService/managedClusters/agentPools]`

This module deploys an Agent Pool for a Container Service Managed Cluster

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerService/managedClusters/agentPools` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `agentPoolProperties` | object |  |  | Required. Properties for the container service agent pool profile. |
| `managedClusterName` | string |  |  | Required. Name of the managed cluster |
| `name` | string |  |  | Required. Name of the agent pool |

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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `agentPoolName` | string | The name of the agent pool |
| `agentPoolResourceGroup` | string | The resource group the agent pool was deployed into. |
| `agentPoolResourceId` | string | The resource ID of the agent pool |

## Template references

- [Managedclusters/Agentpools](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2021-05-01/managedClusters/agentPools)

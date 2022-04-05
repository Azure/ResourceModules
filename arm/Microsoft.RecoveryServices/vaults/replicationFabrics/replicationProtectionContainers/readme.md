# RecoveryServices Vaults ReplicationFabrics ReplicationProtectionContainers `[Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers]`

This module deploys a Replication Protection Container.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers` | 2021-12-01 |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | 2021-12-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication container |
| `recoveryVaultName` | string | Name of the Azure Recovery Service Vault |
| `replicationFabricName` | string | Name of the Replication Fabric |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `replicationContainerMappings` | array | `[]` | Replication containers mappings to create. |


### Parameter Usage: `replicationContainerMappings`

```json
"replicationContainerMappings": {
    "value": [
        {
            "targetProtectionContainerId": "/Subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.RecoveryServices/vaults/<<namePrefix>>-az-rsv-dr-001/replicationFabrics/NorthEurope/replicationProtectionContainers/ne-container1",
            "policyId": "/Subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.RecoveryServices/vaults/<<namePrefix>>-az-rsv-dr-001/replicationPolicies/Default_values"
        },
        {
            "name": null, //Optional
            "policyName": "Default_values",
            "targetContainerFabricName": "WestEurope",
            "targetContainerName": "we-container"
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication container. |
| `resourceGroupName` | string | The name of the resource group the replication container was created in. |
| `resourceId` | string | The resource ID of the replication container. |

## Template references

- [Vaults/Replicationfabrics/Replicationprotectioncontainers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-12-01/vaults/replicationFabrics/replicationProtectionContainers)
- [Vaults/Replicationfabrics/Replicationprotectioncontainers/Replicationprotectioncontainermappings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-12-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings)

# RecoveryServices Vaults ReplicationFabrics `[Microsoft.RecoveryServices/vaults/replicationFabrics]`

This module deploys a Replication Fabric for Azure to Azure disaster recovery scenario of Azure Site Recovery.

> Note: this module currently support only the `instanceType: 'Azure'` scenario.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationFabrics` | 2021-12-01 |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers` | 2021-12-01 |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | 2021-12-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `location` | string | `[resourceGroup().location]` | The recovery location the fabric represents |
| `recoveryVaultName` | string |  | Name of the Azure Recovery Service Vault |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `[parameters('location')]` | The name of the fabric |
| `replicationContainers` | array | `[]` | Replication containers to create. |


### Parameter Usage: `replicationContainers`

```json
"replicationContainers": {
    "value": [
        {
            "name": "we-container1",
            "replicationContainerMappings": [ //optional
                {
                    "policyName": "Default_values",
                    "targetContainerName": "we-container2"
                }
            ]
        },
        {
            "name": "we-container2"
        },
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication fabric. |
| `resourceGroupName` | string | The name of the resource group the replication fabric was created in. |
| `resourceId` | string | The resource ID of the replication fabric. |

## Template references

- [Vaults/Replicationfabrics](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-12-01/vaults/replicationFabrics)
- [Vaults/Replicationfabrics/Replicationprotectioncontainers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-12-01/vaults/replicationFabrics/replicationProtectionContainers)
- [Vaults/Replicationfabrics/Replicationprotectioncontainers/Replicationprotectioncontainermappings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-12-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings)

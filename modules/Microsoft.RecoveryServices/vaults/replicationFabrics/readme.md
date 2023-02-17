# RecoveryServices Vaults ReplicationFabrics `[Microsoft.RecoveryServices/vaults/replicationFabrics]`

This module deploys a Replication Fabric for Azure to Azure disaster recovery scenario of Azure Site Recovery.

> Note: this module currently support only the `instanceType: 'Azure'` scenario.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationFabrics` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `location` | string | `[resourceGroup().location]` | The recovery location the fabric represents. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `recoveryVaultName` | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `name` | string | `[parameters('location')]` | The name of the fabric. |
| `replicationContainers` | array | `[]` | Replication containers to create. |


### Parameter Usage: `replicationContainers`

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
replicationContainers: [
    {
        name: 'we-container1'
        replicationContainerMappings: [ //optional
            {
                policyName: 'Default_values'
                targetContainerName: 'we-container2'
            }
        ]
    }
    {
        name: 'we-container2'
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication fabric. |
| `resourceGroupName` | string | The name of the resource group the replication fabric was created in. |
| `resourceId` | string | The resource ID of the replication fabric. |

## Cross-referenced modules

_None_

# Authorization Locks `[Microsoft.Authorization/locks]`

This module deploys Authorization Locks.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `level` | string | `[CanNotDelete, ReadOnly]` | Set lock level. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[deployment().location]` | Location for all resources. |
| `notes` | string | `[if(equals(parameters('level'), 'CanNotDelete'), 'Cannot delete resource or child resources.', 'Cannot modify the resource or child resources.')]` | The decription attached to the lock. |
| `resourceGroupName` | string | `''` | Name of the Resource Group to assign the lock to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided lock to the resource group. |
| `subscriptionId` | string | `''` | Subscription ID of the subscription to assign the lock to. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the lock. |
| `resourceId` | string | The resource ID of the lock. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "level": {
            "value": "CanNotDelete"
        },
        "resourceGroupName": {
            "value": "validation-rg"
        },
        "subscriptionId": {
            "value": "<<subscriptionId>>"
        }
    }
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module locks './Microsoft.Authorization/locks/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-locks'
  params: {
    level: 'CanNotDelete'
    resourceGroupName: 'validation-rg'
    subscriptionId: '<<subscriptionId>>'
  }
```

</details>
<p>

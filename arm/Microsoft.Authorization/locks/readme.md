# Authorization Locks `[Microsoft.Authorization/locks]`

This module deploys Authorization Locks.
// TODO: Replace Resource and fill in description

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
| `name` | string | `[format('{0}-lock', parameters('level'))]` | The name of the lock. |
| `notes` | string | `[if(equals(parameters('level'), 'CanNotDelete'), 'Cannot delete resource or child resources.', 'Cannot modify the resource or child resources.')]` | The decription attached to the lock. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

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
  }
```

</details>
<p>

# Resources Tags ResourceGroups `[Microsoft.Resources/tags/resourceGroups]`

This module deploys Resources Tags on a resource group scope.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Resources/tags` | 2019-10-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `name` | string | `default` |  | Optional. The name of the tags resource. |
| `onlyUpdate` | bool |  |  | Optional. Instead of overwriting the existing tags, combine them with the new tags |
| `tags` | object | `{object}` |  | Optional. Tags for the resource group. If not provided, removes existing tags |

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
| `name` | string | The name of the tags resource |
| `resourceGroupName` | string | The name of the resource group the tags were applied to |
| `resourceId` | string | The resourceId of the resource group the tags were applied to |
| `tags` | object | The applied tags |

## Template references

- [Tags](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-10-01/tags)

# Resources Tags `[Microsoft.Resources/tags]`

This module deploys Resources Tags on a subscription or resource group scope.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Resources/tags` | 2019-10-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `onlyUpdate` | bool |  |  | Optional. Instead of overwriting the existing tags, combine them with the new tags |
| `resourceGroupName` | string |  |  | Optional. Name of the Resource Group to assign the tags to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription. |
| `subscriptionId` | string | `[subscription().id]` |  | Optional. Subscription ID of the subscription to assign the tags to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription. |
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
| `tags` | object | The applied tags |

## Template references

- [Tags](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-10-01/tags)

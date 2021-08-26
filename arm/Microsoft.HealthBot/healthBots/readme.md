# Azure Health Bot

This module deploys an Azure Health Bot.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.HealthBot/healthBots` | 2020-12-08 |
| `Microsoft.Network/bastionHosts/providers/roleAssignments` | 2018-09-01-preview |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `providers/locks` | 2016-09-01 |

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `azureHealthBotName` | string | Required. Name of the resource |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock resource from deletion. | False |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `sku` | string | Optional. The resource model definition representing SKU. | F0 |  |
| `tags` | object | Optional. Tags of the resource. |  |  |

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

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `azureHealthBotName` | string | The name of the resource. |
| `azureHealthBotResourceGroup` | string | The Resource Group the resource was deployed. |
| `azureHealthBotResourceId` | string | The Resource ID of the resource. |

## Considerations

*N/A*

## Additional resources

- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Azure Resource Manager template reference](https://docs.microsoft.com/en-us/azure/templates/)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [HealtHBots](https://docs.microsoft.com/en-us/azure/templates/Microsoft.HealthBot/2020-12-08/healthBots)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)

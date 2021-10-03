# Resource Group

This module deploys Resource Groups.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/resourceGroups`|2018-05-01|
|`Microsoft.Resources/deployments`|2018-05-01|
|`Microsoft.Authorization/locks`|2016-09-01|
|`Microsoft.Authorization/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `location` | string | Optional. Location of the Resource Group. It uses the deployment's location when not provided. | [deployment().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock storage from deletion. | False |  |
| `resourceGroupName` | string | Required. The name of the Resource Group |  |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Tags of the storage account resource. |  |  |

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
| `resourceGroupName` | string | The name of the Resource Group |
| `resourceGroupResourceId` | string | The resource id of the Resource Group |

### Scripts

- There is no Scripts for this Module

## Considerations

- There is no deployment considerations for this Module

## Additional resources

- [Microsoft Resource Group template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.resources/2019-05-01/resourcegroups)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)

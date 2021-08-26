# Shared Image Gallery

This module deploys Share Image Gallery, with resource lock.


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2019-10-01|
|`Microsoft.Compute/galleries`|2019-12-01|
|`providers/locks`|2016-09-01|
|`Microsoft.Compute/galleries/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `galleryDescription` | string | Optional. Description of the Azure Shared Image Gallery |  |  |
| `galleryName` | string | Required. Name of the Azure Shared Image Gallery |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock resources from deletion. | False |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Tags for all resources. |  |  |

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
| `galleryName` | string | The Name of the Shared Image Gallery. |
| `galleryResourceGroup` | string | The name of the Resource Group the Shared Image Gallery was created in.|
| `galleryResourceId` | string | The Resource Id of the Shared Image Gallery. |

## Considerations

*N/A*

## Additional resources

- [Shared Image Galleries overview](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/shared-image-galleries)
- [Microsoft.Compute galleries template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2019-07-01/galleries)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)

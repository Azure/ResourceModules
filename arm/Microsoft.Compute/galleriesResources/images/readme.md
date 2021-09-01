# Shared Image Definition

This module deploys an Image Definition in a Shared Image Gallery.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Compute/galleries/images`|2019-12-01|
|`Microsoft.Compute/galleries/images/providers/roleAssignments`|2018-09-01-preview|
|`Microsoft.Resources/deployments`|2020-06-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `endOfLife` | string | Optional. The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z |  |  |
| `eula` | string | Optional. The Eula agreement for the gallery Image Definition. Has to be a valid URL. |  |  |
| `excludedDiskTypes` | array | Optional. List of the excluded disk types. E.g. Standard_LRS | System.Object[] |  |
| `galleryName` | string | Required. Name of the Azure Shared Image Gallery |  |  |
| `hyperVGeneration` | string | Optional. The hypervisor generation of the Virtual Machine. Applicable to OS disks only. - V1 or V2 | V1 | System.Object[] |
| `imageDefinitionDescription` | string | Optional. The description of this gallery Image Definition resource. This property is updatable. |  |  |
| `imageDefinitionName` | string | Required. Name of the image definition. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `maxRecommendedMemory` | int | Optional. The maximum amount of RAM in GB recommended for this image. | 16 |  |
| `maxRecommendedvCPUs` | int | Optional. The maximum number of the CPU cores recommended for this image. | 4 |  |
| `minRecommendedMemory` | int | Optional. The minimum amount of RAM in GB recommended for this image. | 4 |  |
| `minRecommendedvCPUs` | int | Optional. The minimum number of the CPU cores recommended for this image. | 1 |  |
| `offer` | string | Optional. The name of the gallery Image Definition offer. | WindowsServer |  |
| `osState` | string | Optional. This property allows the user to specify whether the virtual machines created under this image are 'Generalized' or 'Specialized'. | Generalized | System.Object[] |
| `osType` | string | Optional. OS type of the image to be created. | Windows | System.Object[] |
| `planName` | string | Optional. The plan ID. |  |  |
| `planPublisherName` | string | Optional. The publisher ID. |  |  |
| `privacyStatementUri` | string | Optional. The privacy statement uri. Has to be a valid URL. |  |  |
| `productName` | string | Optional. The product ID. |  |  |
| `publisher` | string | Optional. The name of the gallery Image Definition publisher. | MicrosoftWindowsServer |  |
| `releaseNoteUri` | string | Optional. The release note uri. Has to be a valid URL. |  |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `sku` | string | Optional. The name of the gallery Image Definition SKU. | 2019-Datacenter |  |
| `tags` | object | Optional. Tags for all resources. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |

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
| `galleryResourceGroup` | string | The name of the Resource Group the Shared Image Gallery was created in. |
| `galleryResourceId` | string | The Resource Id of the Shared Image Gallery. |
| `imageDefinitionName` | string | The Name of the Shared Image Definition. |
| `imageDefinitionResourceId` | string | The Resource Id of the Shared Image Definition. |

## Considerations

*N/A*

## Additional resources

- [Shared Image Galleries overview](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/shared-image-galleries)
- [Microsoft.Compute galleries/images template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2019-07-01/galleries/images)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)

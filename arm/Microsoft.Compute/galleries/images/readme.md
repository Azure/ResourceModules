# Shared Image Definition `[Microsoft.Compute/galleries/images]`

This module deploys an Image Definition in a Shared Image Gallery.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Compute/galleries/images` | 2020-09-30 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `endOfLife` | string |  |  | Optional. The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z |
| `eula` | string |  |  | Optional. The Eula agreement for the gallery Image Definition. Has to be a valid URL. |
| `excludedDiskTypes` | array | `[]` |  | Optional. List of the excluded disk types. E.g. Standard_LRS |
| `galleryName` | string |  |  | Required. Name of the Azure Shared Image Gallery |
| `hyperVGeneration` | string | `V1` | `[V1, V2]` | Optional. The hypervisor generation of the Virtual Machine. Applicable to OS disks only. - V1 or V2 |
| `imageDefinitionDescription` | string |  |  | Optional. The description of this gallery Image Definition resource. This property is updatable. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `maxRecommendedMemory` | int | `16` |  | Optional. The maximum amount of RAM in GB recommended for this image. |
| `maxRecommendedvCPUs` | int | `4` |  | Optional. The maximum number of the CPU cores recommended for this image. |
| `minRecommendedMemory` | int | `4` |  | Optional. The minimum amount of RAM in GB recommended for this image. |
| `minRecommendedvCPUs` | int | `1` |  | Optional. The minimum number of the CPU cores recommended for this image. |
| `name` | string |  |  | Required. Name of the image definition. |
| `offer` | string | `WindowsServer` |  | Optional. The name of the gallery Image Definition offer. |
| `osState` | string | `Generalized` | `[Generalized, Specialized]` | Optional. This property allows the user to specify whether the virtual machines created under this image are 'Generalized' or 'Specialized'. |
| `osType` | string | `Windows` | `[Windows, Linux]` | Optional. OS type of the image to be created. |
| `planName` | string |  |  | Optional. The plan ID. |
| `planPublisherName` | string |  |  | Optional. The publisher ID. |
| `privacyStatementUri` | string |  |  | Optional. The privacy statement uri. Has to be a valid URL. |
| `productName` | string |  |  | Optional. The product ID. |
| `publisher` | string | `MicrosoftWindowsServer` |  | Optional. The name of the gallery Image Definition publisher. |
| `releaseNoteUri` | string |  |  | Optional. The release note uri. Has to be a valid URL. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sku` | string | `2019-Datacenter` |  | Optional. The name of the gallery Image Definition SKU. |
| `tags` | object | `{object}` |  | Optional. Tags for all resources. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
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
| `imageName` | string | The name of the image |
| `imageResourceGroup` | string | The resource group the image was deployed into |
| `imageResourceId` | string | The resource ID of the image |

## Template references

- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Galleries/Images](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2020-09-30/galleries/images)

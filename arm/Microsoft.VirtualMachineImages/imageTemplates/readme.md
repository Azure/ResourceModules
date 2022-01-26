# Image Templates `[Microsoft.VirtualMachineImages/imageTemplates]`

This module deploys an image template that can be consumed by the Azure Image Builder (AIB) service.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.VirtualMachineImages/imageTemplates` | 2020-02-14 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('yyyy-MM-dd-HH-mm-ss')]` |  | Generated. Do not provide a value! This date value is used to generate a unique image template name. |
| `buildTimeoutInMinutes` | int |  |  | Optional. Image build timeout in minutes. Allowed values: 0-960. 0 means the default 240 minutes |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `customizationSteps` | array |  |  | Required. Customization steps to be run when building the VM image. |
| `imageReplicationRegions` | array | `[]` |  | Optional. List of the regions the image produced by this solution should be stored in the Shared Image Gallery. When left empty, the deployment's location will be taken as a default value. |
| `imageSource` | object |  |  | Required. Image source definition in object format. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `managedImageName` | string |  |  | Optional. Name of the managed image that will be created in the AIB resourcegroup. |
| `name` | string |  |  | Required. Name of the Image Template to be built by the Azure Image Builder service. |
| `osDiskSizeGB` | int | `128` |  | Optional. Specifies the size of OS disk. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sigImageDefinitionId` | string |  |  | Optional. Resource ID of Shared Image Gallery to distribute image to, e.g.: /subscriptions/<subscriptionID>/resourceGroups/<SIG resourcegroup>/providers/Microsoft.Compute/galleries/<SIG name>/images/<image definition> |
| `subnetId` | string |  |  | Optional. Resource ID of an already existing subnet, e.g. '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>'. If no value is provided, a new VNET will be created in the target Resource Group. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `unManagedImageName` | string |  |  | Optional. Name of the unmanaged image that will be created in the AIB resourcegroup. |
| `userMsiName` | string |  |  | Required. Name of the User Assigned Identity to be used to deploy Image Templates in Azure Image Builder. |
| `userMsiResourceGroup` | string | `[resourceGroup().name]` |  | Optional. Resource group of the user assigned identity. |
| `vmSize` | string | `Standard_D2s_v3` |  | Optional. Specifies the size for the VM. |

### Parameter Usage: `imageSource`

Tag names and tag values can be provided as needed. A tag can be left without a value.

#### Platform Image

```json
"source": {
    "type": "PlatformImage",
    "publisher": "MicrosoftWindowsDesktop",
    "offer": "Windows-10",
    "sku": "19h2-evd",
    "version": "latest"
}
```

#### Managed Image

```json
"source": {
    "type": "ManagedImage",
    "imageId": "/subscriptions/<subscriptionId>/resourceGroups/{destinationResourceGroupName}/providers/Microsoft.Compute/images/<imageName>"
}
```

#### Shared Image

```json
"source": {
    "type": "SharedImageVersion",
    "imageVersionID": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.Compute/galleries/<sharedImageGalleryName>/images/<imageDefinitionName/versions/<imageVersion>"
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the image template |
| `resourceGroupName` | string | The resource group the image template was deployed into |
| `resourceId` | string | The resource ID of the image template |
| `runThisCommand` | string | The command to run in order to trigger the image build |

## Template references

- [Define resources with Bicep and ARM templates](https://docs.microsoft.com/en-us/azure/templates)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

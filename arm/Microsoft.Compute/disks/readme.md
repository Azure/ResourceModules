# Compute Disks `[Microsoft.Compute/disks]`

This template deploys a disk

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Compute/disks` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `acceleratedNetwork` | bool |  |  | Optional. True if the image from which the OS disk is created supports accelerated networking. |
| `burstingEnabled` | bool |  |  | Optional. Set to true to enable bursting beyond the provisioned performance target of the disk. |
| `completionPercent` | int | `100` |  | Optional. Percentage complete for the background copy when a resource is created via the CopyStart operation. |
| `createOption` | string | `Empty` | `[Attach, Copy, CopyStart, Empty, FromImage, Import, ImportSecure, Restore, Upload, UploadPreparedSecure]` | Optional. Sources of a disk creation. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diskIOPSReadWrite` | int |  |  | Optional. The number of IOPS allowed for this disk; only settable for UltraSSD disks. |
| `diskMBpsReadWrite` | int |  |  | Optional. The bandwidth allowed for this disk; only settable for UltraSSD disks. |
| `diskSizeGB` | int |  |  | Optional. If create option is empty, this field is mandatory and it indicates the size of the disk to create. |
| `hyperVGeneration` | string | `V2` | `[V1, V2]` | Optional. The hypervisor generation of the Virtual Machine. Applicable to OS disks only. |
| `imageReferenceId` | string |  |  | Optional. A relative uri containing either a Platform Image Repository or user image reference. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Resource location. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logicalSectorSize` | int | `4096` |  | Optional. Logical sector size in bytes for Ultra disks. Supported values are 512 ad 4096. |
| `maxShares` | int | `1` |  | Optional. The maximum number of VMs that can attach to the disk at the same time. Default value is 0. |
| `name` | string |  |  | Required. The name of the disk that is being created. |
| `networkAccessPolicy` | string | `DenyAll` | `[AllowAll, AllowPrivate, DenyAll]` | Optional. Policy for accessing the disk via network. |
| `osType` | string |  | `[Windows, Linux, ]` | Optional. Sources of a disk creation. |
| `publicNetworkAccess` | string | `Disabled` | `[Disabled, Enabled]` | Optional. Policy for controlling export on the disk. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `securityDataUri` | string |  |  | Optional. If create option is ImportSecure, this is the URI of a blob to be imported into VM guest state. |
| `sku` | string |  | `[Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS, Premium_ZRS, Premium_ZRS]` | Required. The disks sku name. Can be . |
| `sourceResourceId` | string |  |  | Optional. If create option is Copy, this is the ARM ID of the source snapshot or disk. |
| `sourceUri` | string |  |  | Optional. If create option is Import, this is the URI of a blob to be imported into a managed disk. |
| `storageAccountId` | string |  |  | Optional. Required if create option is Import. The Azure Resource Manager identifier of the storage account containing the blob to import as a disk |
| `tags` | object | `{object}` |  | Optional. Tags of the availability set resource. |
| `uploadSizeBytes` | int | `20972032` |  | Optional. If create option is Upload, this is the size of the contents of the upload including the VHD footer. |

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
| `name` | string | The name of the disk |
| `resourceGroupName` | string | The resource group the  disk was deployed into |
| `resourceId` | string | The resource ID of the disk |

## Template references

- [Disks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-08-01/disks)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

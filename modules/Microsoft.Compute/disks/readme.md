# Compute Disks `[Microsoft.Compute/disks]`

This template deploys a disk

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Compute/disks` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-08-01/disks) |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `name` | string |  | The name of the disk that is being created. |
| `sku` | string | `[Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS, Premium_ZRS, Premium_ZRS]` | The disks sku name. Can be . |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `acceleratedNetwork` | bool | `False` |  | True if the image from which the OS disk is created supports accelerated networking. |
| `burstingEnabled` | bool | `False` |  | Set to true to enable bursting beyond the provisioned performance target of the disk. |
| `completionPercent` | int | `100` |  | Percentage complete for the background copy when a resource is created via the CopyStart operation. |
| `createOption` | string | `'Empty'` | `[Attach, Copy, CopyStart, Empty, FromImage, Import, ImportSecure, Restore, Upload, UploadPreparedSecure]` | Sources of a disk creation. |
| `diskIOPSReadWrite` | int | `0` |  | The number of IOPS allowed for this disk; only settable for UltraSSD disks. |
| `diskMBpsReadWrite` | int | `0` |  | The bandwidth allowed for this disk; only settable for UltraSSD disks. |
| `diskSizeGB` | int | `0` |  | If create option is empty, this field is mandatory and it indicates the size of the disk to create. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `hyperVGeneration` | string | `'V2'` | `[V1, V2]` | The hypervisor generation of the Virtual Machine. Applicable to OS disks only. |
| `imageReferenceId` | string | `''` |  | A relative uri containing either a Platform Image Repository or user image reference. |
| `location` | string | `[resourceGroup().location]` |  | Resource location. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `logicalSectorSize` | int | `4096` |  | Logical sector size in bytes for Ultra disks. Supported values are 512 ad 4096. |
| `maxShares` | int | `1` |  | The maximum number of VMs that can attach to the disk at the same time. Default value is 0. |
| `networkAccessPolicy` | string | `'DenyAll'` | `[AllowAll, AllowPrivate, DenyAll]` | Policy for accessing the disk via network. |
| `osType` | string | `''` | `[Windows, Linux, ]` | Sources of a disk creation. |
| `publicNetworkAccess` | string | `'Disabled'` | `[Disabled, Enabled]` | Policy for controlling export on the disk. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `securityDataUri` | string | `''` |  | If create option is ImportSecure, this is the URI of a blob to be imported into VM guest state. |
| `sourceResourceId` | string | `''` |  | If create option is Copy, this is the ARM id of the source snapshot or disk. |
| `sourceUri` | string | `''` |  | If create option is Import, this is the URI of a blob to be imported into a managed disk. |
| `storageAccountId` | string | `''` |  | Required if create option is Import. The Azure Resource Manager identifier of the storage account containing the blob to import as a disk. |
| `tags` | object | `{object}` |  | Tags of the availability set resource. |
| `uploadSizeBytes` | int | `20972032` |  | If create option is Upload, this is the size of the contents of the upload including the VHD footer. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the disk. |
| `resourceGroupName` | string | The resource group the  disk was deployed into. |
| `resourceId` | string | The resource ID of the disk. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-disk-image-001"
        },
        "sku": {
            "value": "Standard_LRS"
        },
        "createOption": {
            "value": "FromImage"
        },
        "imageReferenceId": {
            "value": "/Subscriptions/<<subscriptionId>>/Providers/Microsoft.Compute/Locations/westeurope/Publishers/MicrosoftWindowsServer/ArtifactTypes/VMImage/Offers/WindowsServer/Skus/2016-Datacenter/Versions/14393.4906.2112080838"
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module disks './Microsoft.Compute/disks/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-disks'
  params: {
    name: '<<namePrefix>>-az-disk-image-001'
    sku: 'Standard_LRS'
    createOption: 'FromImage'
    imageReferenceId: '/Subscriptions/<<subscriptionId>>/Providers/Microsoft.Compute/Locations/westeurope/Publishers/MicrosoftWindowsServer/ArtifactTypes/VMImage/Offers/WindowsServer/Skus/2016-Datacenter/Versions/14393.4906.2112080838'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-disk-import-001"
        },
        "sku": {
            "value": "Standard_LRS"
        },
        "createOption": {
            "value": "Import"
        },
        "sourceUri": {
            "value": "https://adp<<namePrefix>>azsax001.blob.core.windows.net/vhds/adp-<<namePrefix>>-az-imgt-x-001.vhd"
        },
        "storageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module disks './Microsoft.Compute/disks/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-disks'
  params: {
    name: '<<namePrefix>>-az-disk-import-001'
    sku: 'Standard_LRS'
    createOption: 'Import'
    sourceUri: 'https://adp<<namePrefix>>azsax001.blob.core.windows.net/vhds/adp-<<namePrefix>>-az-imgt-x-001.vhd'
    storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
  }
}
```

</details>
<p>

<h3>Example 3</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-disk-min-001"
        },
        "sku": {
            "value": "Standard_LRS"
        },
        "diskSizeGB": {
            "value": 1
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module disks './Microsoft.Compute/disks/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-disks'
  params: {
    name: '<<namePrefix>>-az-disk-min-001'
    sku: 'Standard_LRS'
    diskSizeGB: 1
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
  }
}
```

</details>
<p>

<h3>Example 4</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-disk-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "sku": {
            "value": "UltraSSD_LRS"
        },
        "diskSizeGB": {
            "value": 128
        },
        "logicalSectorSize": {
            "value": 512
        },
        "diskIOPSReadWrite": {
            "value": 500
        },
        "diskMBpsReadWrite": {
            "value": 60
        },
        "osType": {
            "value": "Windows"
        },
        "publicNetworkAccess": {
            "value": "Enabled"
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module disks './Microsoft.Compute/disks/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-disks'
  params: {
    name: '<<namePrefix>>-az-disk-x-001'
    lock: 'CanNotDelete'
    sku: 'UltraSSD_LRS'
    diskSizeGB: 128
    logicalSectorSize: 512
    diskIOPSReadWrite: 500
    diskMBpsReadWrite: 60
    osType: 'Windows'
    publicNetworkAccess: 'Enabled'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
  }
}
```

</details>
<p>

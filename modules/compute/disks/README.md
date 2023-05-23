# Compute Disks `[Microsoft.Compute/disks]`

This template deploys a disk

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/disks` | [2022-07-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-07-02/disks) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `name` | string |  | The name of the disk that is being created. |
| `sku` | string | `[Premium_LRS, Premium_ZRS, Premium_ZRS, PremiumV2_LRS, Standard_LRS, StandardSSD_LRS, UltraSSD_LRS]` | The disks sku name. Can be . |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `diskSizeGB` | int | `0` | The size of the disk to create. Required if create option is Empty. |
| `storageAccountId` | string | `''` | The resource ID of the storage account containing the blob to import as a disk. Required if create option is Import. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `acceleratedNetwork` | bool | `False` |  | True if the image from which the OS disk is created supports accelerated networking. |
| `architecture` | string | `''` | `['', Arm64, x64]` | CPU architecture supported by an OS disk. |
| `burstingEnabled` | bool | `False` |  | Set to true to enable bursting beyond the provisioned performance target of the disk. |
| `completionPercent` | int | `100` |  | Percentage complete for the background copy when a resource is created via the CopyStart operation. |
| `createOption` | string | `'Empty'` | `[Attach, Copy, CopyStart, Empty, FromImage, Import, ImportSecure, Restore, Upload, UploadPreparedSecure]` | Sources of a disk creation. |
| `diskIOPSReadWrite` | int | `0` |  | The number of IOPS allowed for this disk; only settable for UltraSSD disks. |
| `diskMBpsReadWrite` | int | `0` |  | The bandwidth allowed for this disk; only settable for UltraSSD disks. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `hyperVGeneration` | string | `'V2'` | `[V1, V2]` | The hypervisor generation of the Virtual Machine. Applicable to OS disks only. |
| `imageReferenceId` | string | `''` |  | A relative uri containing either a Platform Image Repository or user image reference. |
| `location` | string | `[resourceGroup().location]` |  | Resource location. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `logicalSectorSize` | int | `4096` |  | Logical sector size in bytes for Ultra disks. Supported values are 512 ad 4096. |
| `maxShares` | int | `1` |  | The maximum number of VMs that can attach to the disk at the same time. Default value is 0. |
| `networkAccessPolicy` | string | `'DenyAll'` | `[AllowAll, AllowPrivate, DenyAll]` | Policy for accessing the disk via network. |
| `optimizedForFrequentAttach` | bool | `False` |  | Setting this property to true improves reliability and performance of data disks that are frequently (more than 5 times a day) by detached from one virtual machine and attached to another. This property should not be set for disks that are not detached and attached frequently as it causes the disks to not align with the fault domain of the virtual machine. |
| `osType` | string | `''` | `['', Linux, Windows]` | Sources of a disk creation. |
| `publicNetworkAccess` | string | `'Disabled'` | `[Disabled, Enabled]` | Policy for controlling export on the disk. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `securityDataUri` | string | `''` |  | If create option is ImportSecure, this is the URI of a blob to be imported into VM guest state. |
| `sourceResourceId` | string | `''` |  | If create option is Copy, this is the ARM ID of the source snapshot or disk. |
| `sourceUri` | string | `''` |  | If create option is Import, this is the URI of a blob to be imported into a managed disk. |
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

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module disks './compute/disks/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cdcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>-cdcom001'
    sku: 'UltraSSD_LRS'
    // Non-required parameters
    diskIOPSReadWrite: 500
    diskMBpsReadWrite: 60
    diskSizeGB: 128
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    logicalSectorSize: 512
    osType: 'Windows'
    publicNetworkAccess: 'Enabled'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>-cdcom001"
    },
    "sku": {
      "value": "UltraSSD_LRS"
    },
    // Non-required parameters
    "diskIOPSReadWrite": {
      "value": 500
    },
    "diskMBpsReadWrite": {
      "value": 60
    },
    "diskSizeGB": {
      "value": 128
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "logicalSectorSize": {
      "value": 512
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
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Image</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module disks './compute/disks/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cdimg'
  params: {
    // Required parameters
    name: '<<namePrefix>>-cdimg001'
    sku: 'Standard_LRS'
    // Non-required parameters
    createOption: 'FromImage'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    imageReferenceId: '<imageReferenceId>'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>-cdimg001"
    },
    "sku": {
      "value": "Standard_LRS"
    },
    // Non-required parameters
    "createOption": {
      "value": "FromImage"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "imageReferenceId": {
      "value": "<imageReferenceId>"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Import</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module disks './compute/disks/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cdimp'
  params: {
    // Required parameters
    name: '<<namePrefix>>-cdimp001'
    sku: 'Standard_LRS'
    // Non-required parameters
    createOption: 'Import'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    sourceUri: '<sourceUri>'
    storageAccountId: '<storageAccountId>'
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>-cdimp001"
    },
    "sku": {
      "value": "Standard_LRS"
    },
    // Non-required parameters
    "createOption": {
      "value": "Import"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "sourceUri": {
      "value": "<sourceUri>"
    },
    "storageAccountId": {
      "value": "<storageAccountId>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 4: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module disks './compute/disks/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cdmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>-cdmin001'
    sku: 'Standard_LRS'
    // Non-required parameters
    diskSizeGB: 1
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>-cdmin001"
    },
    "sku": {
      "value": "Standard_LRS"
    },
    // Non-required parameters
    "diskSizeGB": {
      "value": 1
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

# Images `[Microsoft.Compute/images]`

This module deploys a compute image.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/images` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/images) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the image. |
| `osDiskBlobUri` | string | The Virtual Hard Disk. |
| `osType` | string | This property allows you to specify the type of the OS that is included in the disk if creating a VM from a custom image. - Windows or Linux. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `dataDisks` | array | `[]` |  | Specifies the parameters that are used to add a data disk to a virtual machine. |
| `diskEncryptionSetResourceId` | string | `''` |  | Specifies the customer managed disk encryption set resource ID for the managed image disk. |
| `diskSizeGB` | int | `128` |  | Specifies the size of empty data disks in gigabytes. This element can be used to overwrite the name of the disk in a virtual machine image. This value cannot be larger than 1023 GB. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `extendedLocation` | object | `{object}` |  | The extended location of the Image. |
| `hyperVGeneration` | string | `'V1'` |  | Gets the HyperVGenerationType of the VirtualMachine created from the image. - V1 or V2. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `managedDiskResourceId` | string | `''` |  | The managedDisk. |
| `osAccountType` | string |  |  | Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can only be used with data disks, it cannot be used with OS Disk. - Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS. |
| `osDiskCaching` | string |  |  | Specifies the caching requirements. Default: None for Standard storage. ReadOnly for Premium storage. - None, ReadOnly, ReadWrite. |
| `osState` | string | `'Generalized'` | `[Generalized, Specialized]` | The OS State. For managed images, use Generalized. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `snapshotResourceId` | string | `''` |  | The snapshot resource ID. |
| `sourceVirtualMachineResourceId` | string | `''` |  | The source virtual machine from which Image is created. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `zoneResilient` | bool | `False` |  | Default is false. Specifies whether an image is zone resilient or not. Zone resilient images can be created only in regions that provide Zone Redundant Storage (ZRS). |


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
| `name` | string | The name of the image. |
| `resourceGroupName` | string | The resource group the image was deployed into. |
| `resourceId` | string | The resource ID of the image. |

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
module images './compute/images/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cicom'
  params: {
    // Required parameters
    name: '<<namePrefix>>cicom001'
    osAccountType: 'Premium_LRS'
    osDiskBlobUri: '<osDiskBlobUri>'
    osDiskCaching: 'ReadWrite'
    osType: 'Windows'
    // Non-required parameters
    diskEncryptionSetResourceId: '<diskEncryptionSetResourceId>'
    diskSizeGB: 128
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    hyperVGeneration: 'V1'
    osState: 'Generalized'
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
      tagA: 'You\'re it'
      tagB: 'Player'
    }
    zoneResilient: true
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
      "value": "<<namePrefix>>cicom001"
    },
    "osAccountType": {
      "value": "Premium_LRS"
    },
    "osDiskBlobUri": {
      "value": "<osDiskBlobUri>"
    },
    "osDiskCaching": {
      "value": "ReadWrite"
    },
    "osType": {
      "value": "Windows"
    },
    // Non-required parameters
    "diskEncryptionSetResourceId": {
      "value": "<diskEncryptionSetResourceId>"
    },
    "diskSizeGB": {
      "value": 128
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "hyperVGeneration": {
      "value": "V1"
    },
    "osState": {
      "value": "Generalized"
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
        "tagA": "You\"re it",
        "tagB": "Player"
      }
    },
    "zoneResilient": {
      "value": true
    }
  }
}
```

</details>
<p>

# Images `[Microsoft.Compute/images]`

This module deploys a compute image.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Compute/images` | 2021-04-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the image. |
| `osDiskBlobUri` | string | The Virtual Hard Disk. |
| `osType` | string | This property allows you to specify the type of the OS that is included in the disk if creating a VM from a custom image. - Windows or Linux |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `hyperVGeneration` | string | `'V1'` | Gets the HyperVGenerationType of the VirtualMachine created from the image. - V1 or V2 |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `osAccountType` | string |  | Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can only be used with data disks, it cannot be used with OS Disk. - Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS |
| `osDiskCaching` | string |  | Specifies the caching requirements. Default: None for Standard storage. ReadOnly for Premium storage. - None, ReadOnly, ReadWrite |
| `roleAssignments` | array | `[]` | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` | Tags of the resource. |
| `zoneResilient` | bool | `False` | Default is false. Specifies whether an image is zone resilient or not. Zone resilient images can be created only in regions that provide Zone Redundant Storage (ZRS). |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

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
| `name` | string | The name of the image |
| `resourceGroupName` | string | The resource group the image was deployed into |
| `resourceId` | string | The resource ID of the image |

## Template references

- [Images](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-04-01/images)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

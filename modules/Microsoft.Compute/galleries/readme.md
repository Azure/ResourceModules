# Azure Compute Galleries `[Microsoft.Compute/galleries]`

This module deploys an Azure compute gallery (formerly known as shared image gallery).

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
| `Microsoft.Compute/galleries` | [2021-10-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-10-01/galleries) |
| `Microsoft.Compute/galleries/images` | [2021-10-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-10-01/galleries/images) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Azure Shared Image Gallery. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `galleryDescription` | string | `''` |  | Description of the Azure Shared Image Gallery. |
| `images` | _[images](images/readme.md)_ array | `[]` |  | Images to create. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags for all resources. |


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
| `name` | string | The name of the deployed image gallery. |
| `resourceGroupName` | string | The resource group of the deployed image gallery. |
| `resourceId` | string | The resource ID of the deployed image gallery. |

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
            "value": "<<namePrefix>>azsigweuimages001"
        },
        "images": {
            "value": [
                {
                    "name": "<<namePrefix>>-az-imgd-x-003"
                },
                {
                    "name": "<<namePrefix>>-az-imgd-x-001",
                    "osType": "Windows",
                    "osState": "Generalized",
                    "publisher": "MicrosoftWindowsServer",
                    "offer": "WindowsServer",
                    "sku": "2022-datacenter-azure-edition",
                    "minRecommendedvCPUs": 2,
                    "maxRecommendedvCPUs": 8,
                    "minRecommendedMemory": 4,
                    "maxRecommendedMemory": 16,
                    "hyperVGeneration": "V1",
                    "roleAssignments": [
                        {
                            "roleDefinitionIdOrName": "Reader",
                            "principalIds": [
                                "<<deploymentSpId>>"
                            ]
                        }
                    ]
                },
                {
                    "name": "<<namePrefix>>-az-imgd-x-002",
                    "osType": "Linux",
                    "osState": "Generalized",
                    "publisher": "canonical",
                    "offer": "0001-com-ubuntu-server-focal",
                    "sku": "20_04-lts-gen2",
                    "minRecommendedvCPUs": 1,
                    "maxRecommendedvCPUs": 4,
                    "minRecommendedMemory": 4,
                    "maxRecommendedMemory": 32,
                    "hyperVGeneration": "V2"
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
module galleries './Microsoft.Compute/galleries/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-galleries'
  params: {
    name: '<<namePrefix>>azsigweuimages001'
    images: [
      {
        name: '<<namePrefix>>-az-imgd-x-003'
      }
      {
        name: '<<namePrefix>>-az-imgd-x-001'
        osType: 'Windows'
        osState: 'Generalized'
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        minRecommendedvCPUs: 2
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        maxRecommendedMemory: 16
        hyperVGeneration: 'V1'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              '<<deploymentSpId>>'
            ]
          }
        ]
      }
      {
        name: '<<namePrefix>>-az-imgd-x-002'
        osType: 'Linux'
        osState: 'Generalized'
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        minRecommendedvCPUs: 1
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        maxRecommendedMemory: 32
        hyperVGeneration: 'V2'
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
            "value": "<<namePrefix>>azsigweux001"
        },
        "lock": {
            "value": "CanNotDelete"
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
module galleries './Microsoft.Compute/galleries/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-galleries'
  params: {
    name: '<<namePrefix>>azsigweux001'
    lock: 'CanNotDelete'
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

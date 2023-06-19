# Azure Compute Galleries `[Microsoft.Compute/galleries]`

This module deploys an Azure Compute Gallery (formerly known as Shared Image Gallery).

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
| `Microsoft.Compute/galleries` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries) |
| `Microsoft.Compute/galleries/applications` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/applications) |
| `Microsoft.Compute/galleries/images` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/images) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Azure Compute Gallery. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `applications` | _[applications](applications/README.md)_ array | `[]` |  | Applications to create. |
| `description` | string | `''` |  | Description of the Azure Shared Image Gallery. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `images` | _[images](images/README.md)_ array | `[]` |  | Images to create. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
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
module galleries './compute/galleries/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cgcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>cgcom001'
    // Non-required parameters
    applications: [
      {
        name: '<<namePrefix>>-cgcom-appd-001'
      }
      {
        name: '<<namePrefix>>-cgcom-appd-002'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        supportedOSType: 'Windows'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    images: [
      {
        name: '<<namePrefix>>-az-imgd-ws-001'
      }
      {
        hyperVGeneration: 'V1'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: '<<namePrefix>>-az-imgd-ws-002'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition'
      }
      {
        hyperVGeneration: 'V2'
        isHibernateSupported: 'true'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: '<<namePrefix>>-az-imgd-ws-003'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition-hibernate'
      }
      {
        hyperVGeneration: 'V2'
        isAcceleratedNetworkSupported: 'true'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: '<<namePrefix>>-az-imgd-ws-004'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition-accnet'
      }
      {
        hyperVGeneration: 'V2'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: '<<namePrefix>>-az-imgd-wdtl-002'
        offer: 'WindowsDesktop'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsDesktop'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        securityType: 'TrustedLaunch'
        sku: 'Win11-21H2'
      }
      {
        hyperVGeneration: 'V2'
        maxRecommendedMemory: 32
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        minRecommendedvCPUs: 1
        name: '<<namePrefix>>-az-imgd-us-001'
        offer: '0001-com-ubuntu-server-focal'
        osState: 'Generalized'
        osType: 'Linux'
        publisher: 'canonical'
        sku: '20_04-lts-gen2'
      }
    ]
    lock: 'CanNotDelete'
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
      "value": "<<namePrefix>>cgcom001"
    },
    // Non-required parameters
    "applications": {
      "value": [
        {
          "name": "<<namePrefix>>-cgcom-appd-001"
        },
        {
          "name": "<<namePrefix>>-cgcom-appd-002",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "supportedOSType": "Windows"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "images": {
      "value": [
        {
          "name": "<<namePrefix>>-az-imgd-ws-001"
        },
        {
          "hyperVGeneration": "V1",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "<<namePrefix>>-az-imgd-ws-002",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition"
        },
        {
          "hyperVGeneration": "V2",
          "isHibernateSupported": "true",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "<<namePrefix>>-az-imgd-ws-003",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition-hibernate"
        },
        {
          "hyperVGeneration": "V2",
          "isAcceleratedNetworkSupported": "true",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "<<namePrefix>>-az-imgd-ws-004",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition-accnet"
        },
        {
          "hyperVGeneration": "V2",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 4,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "<<namePrefix>>-az-imgd-wdtl-002",
          "offer": "WindowsDesktop",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsDesktop",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "securityType": "TrustedLaunch",
          "sku": "Win11-21H2"
        },
        {
          "hyperVGeneration": "V2",
          "maxRecommendedMemory": 32,
          "maxRecommendedvCPUs": 4,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 1,
          "name": "<<namePrefix>>-az-imgd-us-001",
          "offer": "0001-com-ubuntu-server-focal",
          "osState": "Generalized",
          "osType": "Linux",
          "publisher": "canonical",
          "sku": "20_04-lts-gen2"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
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

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module galleries './compute/galleries/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cgmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>cgmin001'
    // Non-required parameters
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
      "value": "<<namePrefix>>cgmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

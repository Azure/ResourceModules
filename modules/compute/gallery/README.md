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
| `applications` | array | `[]` |  | Applications to create. |
| `description` | string | `''` |  | Description of the Azure Shared Image Gallery. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `images` | array | `[]` |  | Images to create. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags for all resources. |


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
module gallery './compute/gallery/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cgcom'
  params: {
    // Required parameters
    name: 'cgcom001'
    // Non-required parameters
    applications: [
      {
        name: 'cgcom-appd-001'
      }
      {
        name: 'cgcom-appd-002'
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
        name: 'az-imgd-ws-001'
      }
      {
        hyperVGeneration: 'V1'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-ws-002'
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
        name: 'az-imgd-ws-003'
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
        name: 'az-imgd-ws-004'
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
        name: 'az-imgd-wdtl-002'
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
        name: 'az-imgd-us-001'
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
      'hidden-title': 'This is visible in the resource name'
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
      "value": "cgcom001"
    },
    // Non-required parameters
    "applications": {
      "value": [
        {
          "name": "cgcom-appd-001"
        },
        {
          "name": "cgcom-appd-002",
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
          "name": "az-imgd-ws-001"
        },
        {
          "hyperVGeneration": "V1",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-ws-002",
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
          "name": "az-imgd-ws-003",
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
          "name": "az-imgd-ws-004",
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
          "name": "az-imgd-wdtl-002",
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
          "name": "az-imgd-us-001",
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
        "hidden-title": "This is visible in the resource name",
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
module gallery './compute/gallery/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cgmin'
  params: {
    // Required parameters
    name: 'cgmin001'
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
      "value": "cgmin001"
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

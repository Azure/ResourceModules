# Network Watchers `[Microsoft.Network/networkWatchers]`

- This template deploys a network watcher.
- Network Watcher is a default resource which will get created automatically in every region where a virtual network is present with in the network watcher resource group.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/networkWatchers` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkWatchers) |
| `Microsoft.Network/networkWatchers/connectionMonitors` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkWatchers/connectionMonitors) |
| `Microsoft.Network/networkWatchers/flowLogs` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkWatchers/flowLogs) |

## Parameters

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `connectionMonitors` | _[connectionMonitors](connectionMonitors/readme.md)_ array | `[]` |  | Array that contains the Connection Monitors. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `flowLogs` | _[flowLogs](flowLogs/readme.md)_ array | `[]` |  | Array that contains the Flow Logs. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `name` | string | `[format('NetworkWatcher_{0}', parameters('location'))]` |  | Name of the Network Watcher resource (hidden). |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |


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
| `name` | string | The name of the deployed network watcher. |
| `resourceGroupName` | string | The resource group the network watcher was deployed into. |
| `resourceId` | string | The resource ID of the deployed network watcher. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module networkWatchers './Microsoft.Network/networkWatchers/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-NetworkWatchers'
  params: {
    location: 'northeurope'
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
    "location": {
      "value": "northeurope"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Parameters</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module networkWatchers './Microsoft.Network/networkWatchers/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-NetworkWatchers'
  params: {
    connectionMonitors: [
      {
        endpoints: [
          {
            name: '<<namePrefix>>-az-subnet-x-001(validation-rg)'
            resourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Compute/virtualMachines/adp-<<namePrefix>>-vm-01'
            type: 'AzureVM'
          }
          {
            address: 'www.office.com'
            name: 'Office Portal'
            type: 'ExternalAddress'
          }
        ]
        name: 'adp-<<namePrefix>>-az-conn-mon-x-001'
        testConfigurations: [
          {
            httpConfiguration: {
              method: 'Get'
              port: 80
              preferHTTPS: false
              requestHeaders: []
              validStatusCodeRanges: [
                '200'
              ]
            }
            name: 'HTTP Test'
            protocol: 'Http'
            successThreshold: {
              checksFailedPercent: 5
              roundTripTimeMs: 100
            }
            testFrequencySec: 30
          }
        ]
        testGroups: [
          {
            destinations: [
              'Office Portal'
            ]
            disable: false
            name: 'TestHTTPBing'
            sources: [
              '<<namePrefix>>-az-subnet-x-001(validation-rg)'
            ]
            testConfigurations: [
              'HTTP Test'
            ]
          }
        ]
        workspaceResourceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
      }
    ]
    flowLogs: [
      {
        enabled: false
        storageId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
        targetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/networkSecurityGroups/adp-<<namePrefix>>-az-nsg-x-001'
      }
      {
        formatVersion: 1
        name: 'adp-<<namePrefix>>-az-nsg-x-apgw-flowlog'
        retentionInDays: 8
        storageId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
        targetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/networkSecurityGroups/adp-<<namePrefix>>-az-nsg-x-apgw'
        trafficAnalyticsInterval: 10
        workspaceResourceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
      }
    ]
    name: 'adp-<<namePrefix>>-az-nw-x-001'
    roleAssignments: [
      {
        principalIds: [
          '<<deploymentSpId>>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
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
    "connectionMonitors": {
      "value": [
        {
          "endpoints": [
            {
              "name": "<<namePrefix>>-az-subnet-x-001(validation-rg)",
              "resourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Compute/virtualMachines/adp-<<namePrefix>>-vm-01",
              "type": "AzureVM"
            },
            {
              "address": "www.office.com",
              "name": "Office Portal",
              "type": "ExternalAddress"
            }
          ],
          "name": "adp-<<namePrefix>>-az-conn-mon-x-001",
          "testConfigurations": [
            {
              "httpConfiguration": {
                "method": "Get",
                "port": 80,
                "preferHTTPS": false,
                "requestHeaders": [],
                "validStatusCodeRanges": [
                  "200"
                ]
              },
              "name": "HTTP Test",
              "protocol": "Http",
              "successThreshold": {
                "checksFailedPercent": 5,
                "roundTripTimeMs": 100
              },
              "testFrequencySec": 30
            }
          ],
          "testGroups": [
            {
              "destinations": [
                "Office Portal"
              ],
              "disable": false,
              "name": "TestHTTPBing",
              "sources": [
                "<<namePrefix>>-az-subnet-x-001(validation-rg)"
              ],
              "testConfigurations": [
                "HTTP Test"
              ]
            }
          ],
          "workspaceResourceId": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        }
      ]
    },
    "flowLogs": {
      "value": [
        {
          "enabled": false,
          "storageId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001",
          "targetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/networkSecurityGroups/adp-<<namePrefix>>-az-nsg-x-001"
        },
        {
          "formatVersion": 1,
          "name": "adp-<<namePrefix>>-az-nsg-x-apgw-flowlog",
          "retentionInDays": 8,
          "storageId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001",
          "targetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/networkSecurityGroups/adp-<<namePrefix>>-az-nsg-x-apgw",
          "trafficAnalyticsInterval": 10,
          "workspaceResourceId": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        }
      ]
    },
    "name": {
      "value": "adp-<<namePrefix>>-az-nw-x-001"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<<deploymentSpId>>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    }
  }
}
```

</details>
<p>

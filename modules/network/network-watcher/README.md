# Network Watchers `[Microsoft.Network/networkWatchers]`

This module deploys a Network Watcher.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/networkWatchers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkWatchers) |
| `Microsoft.Network/networkWatchers/connectionMonitors` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkWatchers/connectionMonitors) |
| `Microsoft.Network/networkWatchers/flowLogs` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkWatchers/flowLogs) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.network-watcher:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module networkWatcher 'br:bicep/modules/network.network-watcher:1.0.0' = {
  name: '${uniqueString(deployment().name, testLocation)}-test-nnwcom'
  params: {
    connectionMonitors: [
      {
        endpoints: [
          {
            name: '<name>'
            resourceId: '<resourceId>'
            type: 'AzureVM'
          }
          {
            address: 'www.bing.com'
            name: 'Bing'
            type: 'ExternalAddress'
          }
        ]
        name: 'nnwcom-cm-001'
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
            name: 'HTTP Bing Test'
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
              'Bing'
            ]
            disable: false
            name: 'test-http-Bing'
            sources: [
              'subnet-001(${resourceGroup.name})'
            ]
            testConfigurations: [
              'HTTP Bing Test'
            ]
          }
        ]
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    flowLogs: [
      {
        enabled: false
        storageId: '<storageId>'
        targetResourceId: '<targetResourceId>'
      }
      {
        formatVersion: 1
        name: 'nnwcom-fl-001'
        retentionInDays: 8
        storageId: '<storageId>'
        targetResourceId: '<targetResourceId>'
        trafficAnalyticsInterval: 10
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    name: '<name>'
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
    "connectionMonitors": {
      "value": [
        {
          "endpoints": [
            {
              "name": "<name>",
              "resourceId": "<resourceId>",
              "type": "AzureVM"
            },
            {
              "address": "www.bing.com",
              "name": "Bing",
              "type": "ExternalAddress"
            }
          ],
          "name": "nnwcom-cm-001",
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
              "name": "HTTP Bing Test",
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
                "Bing"
              ],
              "disable": false,
              "name": "test-http-Bing",
              "sources": [
                "subnet-001(${resourceGroup.name})"
              ],
              "testConfigurations": [
                "HTTP Bing Test"
              ]
            }
          ],
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "flowLogs": {
      "value": [
        {
          "enabled": false,
          "storageId": "<storageId>",
          "targetResourceId": "<targetResourceId>"
        },
        {
          "formatVersion": 1,
          "name": "nnwcom-fl-001",
          "retentionInDays": 8,
          "storageId": "<storageId>",
          "targetResourceId": "<targetResourceId>",
          "trafficAnalyticsInterval": 10,
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "<name>"
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module networkWatcher 'br:bicep/modules/network.network-watcher:1.0.0' = {
  name: '${uniqueString(deployment().name, testLocation)}-test-nnwmin'
  params: {
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>


## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionMonitors`](#parameter-connectionmonitors) | array | Array that contains the Connection Monitors. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`flowLogs`](#parameter-flowlogs) | array | Array that contains the Flow Logs. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`name`](#parameter-name) | string | Name of the Network Watcher resource (hidden). |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `connectionMonitors`

Array that contains the Connection Monitors.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `flowLogs`

Array that contains the Flow Logs.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

Name of the Network Watcher resource (hidden).
- Required: No
- Type: string
- Default: `[format('NetworkWatcher_{0}', parameters('location'))]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed network watcher. |
| `resourceGroupName` | string | The resource group the network watcher was deployed into. |
| `resourceId` | string | The resource ID of the deployed network watcher. |

## Cross-referenced modules

_None_

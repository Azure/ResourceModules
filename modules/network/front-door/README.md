# Azure Front Doors `[Microsoft.Network/frontDoors]`

This module deploys an Azure Front Door.

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/frontDoors` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/frontDoors) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.front-door:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using Maximum Parameters](#example-2-using-maximum-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module frontDoor 'br:bicep/modules/network.front-door:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nfdcom'
  params: {
    // Required parameters
    backendPools: [
      {
        name: 'backendPool'
        properties: {
          backends: [
            {
              address: 'biceptest.local'
              backendHostHeader: 'backendAddress'
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              privateLinkAlias: ''
              privateLinkApprovalMessage: ''
              privateLinkLocation: ''
              privateLinkResourceId: ''
              weight: 50
            }
          ]
          HealthProbeSettings: {
            id: '<id>'
          }
          LoadBalancingSettings: {
            id: '<id>'
          }
        }
      }
    ]
    frontendEndpoints: [
      {
        name: 'frontEnd'
        properties: {
          hostName: '<hostName>'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 60
        }
      }
    ]
    healthProbeSettings: [
      {
        name: 'heathProbe'
        properties: {
          enabledState: ''
          healthProbeMethod: ''
          intervalInSeconds: 60
          path: '/'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'loadBalancer'
        properties: {
          additionalLatencyMilliseconds: 0
          sampleSize: 50
          successfulSamplesRequired: 1
        }
      }
    ]
    name: '<name>'
    routingRules: [
      {
        name: 'routingRule'
        properties: {
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: '<id>'
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            backendPool: {
              id: '<id>'
            }
            forwardingProtocol: 'MatchRequest'
          }
        }
      }
    ]
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enforceCertificateNameCheck: 'Disabled'
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
    sendRecvTimeoutSeconds: 10
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
    "backendPools": {
      "value": [
        {
          "name": "backendPool",
          "properties": {
            "backends": [
              {
                "address": "biceptest.local",
                "backendHostHeader": "backendAddress",
                "enabledState": "Enabled",
                "httpPort": 80,
                "httpsPort": 443,
                "priority": 1,
                "privateLinkAlias": "",
                "privateLinkApprovalMessage": "",
                "privateLinkLocation": "",
                "privateLinkResourceId": "",
                "weight": 50
              }
            ],
            "HealthProbeSettings": {
              "id": "<id>"
            },
            "LoadBalancingSettings": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "frontendEndpoints": {
      "value": [
        {
          "name": "frontEnd",
          "properties": {
            "hostName": "<hostName>",
            "sessionAffinityEnabledState": "Disabled",
            "sessionAffinityTtlSeconds": 60
          }
        }
      ]
    },
    "healthProbeSettings": {
      "value": [
        {
          "name": "heathProbe",
          "properties": {
            "enabledState": "",
            "healthProbeMethod": "",
            "intervalInSeconds": 60,
            "path": "/",
            "protocol": "Https"
          }
        }
      ]
    },
    "loadBalancingSettings": {
      "value": [
        {
          "name": "loadBalancer",
          "properties": {
            "additionalLatencyMilliseconds": 0,
            "sampleSize": 50,
            "successfulSamplesRequired": 1
          }
        }
      ]
    },
    "name": {
      "value": "<name>"
    },
    "routingRules": {
      "value": [
        {
          "name": "routingRule",
          "properties": {
            "acceptedProtocols": [
              "Http",
              "Https"
            ],
            "enabledState": "Enabled",
            "frontendEndpoints": [
              {
                "id": "<id>"
              }
            ],
            "patternsToMatch": [
              "/*"
            ],
            "routeConfiguration": {
              "@odata.type": "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration",
              "backendPool": {
                "id": "<id>"
              },
              "forwardingProtocol": "MatchRequest"
            }
          }
        }
      ]
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enforceCertificateNameCheck": {
      "value": "Disabled"
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
    "sendRecvTimeoutSeconds": {
      "value": 10
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

### Example 2: _Using Maximum Parameters_

This instance deploys the module with the large set of possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module frontDoor 'br:bicep/modules/network.front-door:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nfdmin'
  params: {
    // Required parameters
    backendPools: [
      {
        name: 'backendPool'
        properties: {
          backends: [
            {
              address: 'biceptest.local'
              backendHostHeader: 'backendAddress'
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
            }
          ]
          HealthProbeSettings: {
            id: '<id>'
          }
          LoadBalancingSettings: {
            id: '<id>'
          }
        }
      }
    ]
    frontendEndpoints: [
      {
        name: 'frontEnd'
        properties: {
          hostName: '<hostName>'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 60
        }
      }
    ]
    healthProbeSettings: [
      {
        name: 'heathProbe'
        properties: {
          intervalInSeconds: 60
          path: '/'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'loadBalancer'
        properties: {
          additionalLatencyMilliseconds: 0
          sampleSize: 50
          successfulSamplesRequired: 1
        }
      }
    ]
    name: '<name>'
    routingRules: [
      {
        name: 'routingRule'
        properties: {
          acceptedProtocols: [
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: '<id>'
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            backendPool: {
              id: '<id>'
            }
          }
        }
      }
    ]
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
    "backendPools": {
      "value": [
        {
          "name": "backendPool",
          "properties": {
            "backends": [
              {
                "address": "biceptest.local",
                "backendHostHeader": "backendAddress",
                "enabledState": "Enabled",
                "httpPort": 80,
                "httpsPort": 443,
                "priority": 1,
                "weight": 50
              }
            ],
            "HealthProbeSettings": {
              "id": "<id>"
            },
            "LoadBalancingSettings": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "frontendEndpoints": {
      "value": [
        {
          "name": "frontEnd",
          "properties": {
            "hostName": "<hostName>",
            "sessionAffinityEnabledState": "Disabled",
            "sessionAffinityTtlSeconds": 60
          }
        }
      ]
    },
    "healthProbeSettings": {
      "value": [
        {
          "name": "heathProbe",
          "properties": {
            "intervalInSeconds": 60,
            "path": "/",
            "protocol": "Https"
          }
        }
      ]
    },
    "loadBalancingSettings": {
      "value": [
        {
          "name": "loadBalancer",
          "properties": {
            "additionalLatencyMilliseconds": 0,
            "sampleSize": 50,
            "successfulSamplesRequired": 1
          }
        }
      ]
    },
    "name": {
      "value": "<name>"
    },
    "routingRules": {
      "value": [
        {
          "name": "routingRule",
          "properties": {
            "acceptedProtocols": [
              "Https"
            ],
            "enabledState": "Enabled",
            "frontendEndpoints": [
              {
                "id": "<id>"
              }
            ],
            "patternsToMatch": [
              "/*"
            ],
            "routeConfiguration": {
              "@odata.type": "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration",
              "backendPool": {
                "id": "<id>"
              }
            }
          }
        }
      ]
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendPools`](#parameter-backendpools) | array | Backend address pool of the frontdoor resource. |
| [`frontendEndpoints`](#parameter-frontendendpoints) | array | Frontend endpoints of the frontdoor resource. |
| [`healthProbeSettings`](#parameter-healthprobesettings) | array | Heath probe settings of the frontdoor resource. |
| [`loadBalancingSettings`](#parameter-loadbalancingsettings) | array | Load balancing settings of the frontdoor resource. |
| [`name`](#parameter-name) | string | The name of the frontDoor. |
| [`routingRules`](#parameter-routingrules) | array | Routing rules settings of the frontdoor resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enabledState`](#parameter-enabledstate) | string | State of the frontdoor resource. |
| [`enforceCertificateNameCheck`](#parameter-enforcecertificatenamecheck) | string | Enforce certificate name check of the frontdoor resource. |
| [`friendlyName`](#parameter-friendlyname) | string | Friendly name of the frontdoor resource. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`metricsToEnable`](#parameter-metricstoenable) | array | The name of metrics that will be streamed. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`sendRecvTimeoutSeconds`](#parameter-sendrecvtimeoutseconds) | int | Certificate name check time of the frontdoor resource. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `backendPools`

Backend address pool of the frontdoor resource.
- Required: Yes
- Type: array

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, FrontdoorAccessLog, FrontdoorWebApplicationFirewallLog]`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enabledState`

State of the frontdoor resource.
- Required: No
- Type: string
- Default: `'Enabled'`

### Parameter: `enforceCertificateNameCheck`

Enforce certificate name check of the frontdoor resource.
- Required: No
- Type: string
- Default: `'Disabled'`

### Parameter: `friendlyName`

Friendly name of the frontdoor resource.
- Required: No
- Type: string
- Default: `''`

### Parameter: `frontendEndpoints`

Frontend endpoints of the frontdoor resource.
- Required: Yes
- Type: array

### Parameter: `healthProbeSettings`

Heath probe settings of the frontdoor resource.
- Required: Yes
- Type: array

### Parameter: `loadBalancingSettings`

Load balancing settings of the frontdoor resource.
- Required: Yes
- Type: array

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

### Parameter: `metricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[AllMetrics]`
- Allowed: `[AllMetrics]`

### Parameter: `name`

The name of the frontDoor.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `routingRules`

Routing rules settings of the frontdoor resource.
- Required: Yes
- Type: array

### Parameter: `sendRecvTimeoutSeconds`

Certificate name check time of the frontdoor resource.
- Required: No
- Type: int
- Default: `240`

### Parameter: `tags`

Resource tags.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the front door. |
| `resourceGroupName` | string | The resource group the front door was deployed into. |
| `resourceId` | string | The resource ID of the front door. |

## Cross-referenced modules

_None_

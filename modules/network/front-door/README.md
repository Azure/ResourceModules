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

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.front-door:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


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
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
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
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


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
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
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

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

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


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

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

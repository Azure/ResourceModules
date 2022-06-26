# Front Doors `[Microsoft.Network/frontDoors]`

This module deploys Front Doors.


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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/frontDoors` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/frontDoors) |

## Parameters

**Required parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `backendPools` | array | `[]` | Backend address pool of the frontdoor resource. |
| `enabledState` | string | `'Enabled'` | State of the frontdoor resource. |
| `friendlyName` | string | `''` | Friendly name of the frontdoor resource. |
| `frontendEndpoints` | array | `[]` | Frontend endpoints of the frontdoor resource. |
| `healthProbeSettings` | array | `[]` | Heath probe settings of the frontdoor resource. |
| `loadBalancingSettings` | array | `[]` | Load balancing settings of the frontdoor resource. |
| `name` | string |  | The name of the frontDoor. |
| `routingRules` | array | `[]` | Routing rules settings of the frontdoor resource. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enforceCertificateNameCheck` | string | `'Disabled'` |  | Enforce certificate name check of the frontdoor resource. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `logsToEnable` | array | `[FrontdoorAccessLog, FrontdoorWebApplicationFirewallLog]` | `[FrontdoorAccessLog, FrontdoorWebApplicationFirewallLog]` | The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sendRecvTimeoutSeconds` | int | `600` |  | Certificate name check time of the frontdoor resource. |
| `tags` | object | `{object}` |  | Resource tags. |


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
| `name` | string | The name of the front door. |
| `resourceGroupName` | string | The resource group the front door was deployed into. |
| `resourceId` | string | The resource ID of the front door. |

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
            "value": "<<namePrefix>>-az-fd-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "backendPools": {
            "value": [
                {
                    "name": "backendPool",
                    "properties": {
                        "backends": [
                            {
                                "address": "biceptest.local",
                                "backendHostHeader": "backendAddress",
                                "httpPort": 80,
                                "httpsPort": 443,
                                "weight": 50,
                                "priority": 1,
                                "enabledState": "Enabled",
                                "privateLinkAlias": "",
                                "privateLinkApprovalMessage": "",
                                "privateLinkLocation": "",
                                "privateLinkResourceId": ""
                            }
                        ],
                        "LoadBalancingSettings": {
                            "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/frontDoors/<<namePrefix>>-az-fd-x-001/LoadBalancingSettings/loadBalancer"
                        },
                        "HealthProbeSettings": {
                            "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/frontDoors/<<namePrefix>>-az-fd-x-001/HealthProbeSettings/heathProbe"
                        }
                    }
                }
            ]
        },
        "enforceCertificateNameCheck": {
            "value": "Disabled"
        },
        "sendRecvTimeoutSeconds": {
            "value": 10
        },
        "frontendEndpoints": {
            "value": [
                {
                    "name": "frontEnd",
                    "properties": {
                        "hostName": "<<namePrefix>>-az-fd-x-001.azurefd.net",
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
                                "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/frontDoors/<<namePrefix>>-az-fd-x-001/FrontendEndpoints/frontEnd"
                            }
                        ],
                        "patternsToMatch": [
                            "/*"
                        ],
                        "routeConfiguration": {
                            "@odata.type": "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration",
                            "forwardingProtocol": "MatchRequest",
                            "backendPool": {
                                "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/frontDoors/<<namePrefix>>-az-fd-x-001/BackendPools/backendPool"
                            }
                        }
                    }
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
module frontDoors './Microsoft.Network/frontDoors/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-frontDoors'
  params: {
    name: '<<namePrefix>>-az-fd-x-001'
    lock: 'CanNotDelete'
    backendPools: [
      {
        name: 'backendPool'
        properties: {
          backends: [
            {
              address: 'biceptest.local'
              backendHostHeader: 'backendAddress'
              httpPort: 80
              httpsPort: 443
              weight: 50
              priority: 1
              enabledState: 'Enabled'
              privateLinkAlias: ''
              privateLinkApprovalMessage: ''
              privateLinkLocation: ''
              privateLinkResourceId: ''
            }
          ]
          LoadBalancingSettings: {
            id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/frontDoors/<<namePrefix>>-az-fd-x-001/LoadBalancingSettings/loadBalancer'
          }
          HealthProbeSettings: {
            id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/frontDoors/<<namePrefix>>-az-fd-x-001/HealthProbeSettings/heathProbe'
          }
        }
      }
    ]
    enforceCertificateNameCheck: 'Disabled'
    sendRecvTimeoutSeconds: 10
    frontendEndpoints: [
      {
        name: 'frontEnd'
        properties: {
          hostName: '<<namePrefix>>-az-fd-x-001.azurefd.net'
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
              id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/frontDoors/<<namePrefix>>-az-fd-x-001/FrontendEndpoints/frontEnd'
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            forwardingProtocol: 'MatchRequest'
            backendPool: {
              id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/frontDoors/<<namePrefix>>-az-fd-x-001/BackendPools/backendPool'
            }
          }
        }
      }
    ]
  }
}
```

</details>
<p>

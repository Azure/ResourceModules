# Network Security Groups `[Microsoft.Network/networkSecurityGroups]`

This template deploys a network security group (NSG) with optional security rules.

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
| `Microsoft.Network/networkSecurityGroups` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/networkSecurityGroups) |
| `Microsoft.Network/networkSecurityGroups/securityRules` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/networkSecurityGroups/securityRules) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Network Security Group. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[NetworkSecurityGroupEvent, NetworkSecurityGroupRuleCounter]` | `[NetworkSecurityGroupEvent, NetworkSecurityGroupRuleCounter]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `securityRules` | _[securityRules](securityRules/readme.md)_ array | `[]` |  | Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed. |
| `tags` | object | `{object}` |  | Tags of the NSG resource. |


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
| `name` | string | The name of the network security group. |
| `resourceGroupName` | string | The resource group the network security group was deployed into. |
| `resourceId` | string | The resource ID of the network security group. |

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
            "value": "<<namePrefix>>-az-nsg-min-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module networkSecurityGroups './Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-networkSecurityGroups'
  params: {
    name: '<<namePrefix>>-az-nsg-min-001'
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
            "value": "<<namePrefix>>-az-nsg-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "securityRules": {
            "value": [
                {
                    "name": "Specific",
                    "properties": {
                        "description": "Tests specific IPs and ports",
                        "protocol": "*",
                        "sourcePortRange": "*",
                        "destinationPortRange": "8080",
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "*",
                        "access": "Allow",
                        "priority": 100,
                        "direction": "Inbound"
                    }
                },
                {
                    "name": "Ranges",
                    "properties": {
                        "description": "Tests Ranges",
                        "protocol": "*",
                        "access": "Allow",
                        "priority": 101,
                        "direction": "Inbound",
                        "sourcePortRanges": [
                            "80",
                            "81"
                        ],
                        "destinationPortRanges": [
                            "90",
                            "91"
                        ],
                        "sourceAddressPrefixes": [
                            "10.0.0.0/16",
                            "10.1.0.0/16"
                        ],
                        "destinationAddressPrefixes": [
                            "10.2.0.0/16",
                            "10.3.0.0/16"
                        ]
                    }
                },
                {
                    "name": "Port_8082",
                    "properties": {
                        "description": "Allow inbound access on TCP 8082",
                        "protocol": "*",
                        "sourcePortRange": "*",
                        "destinationPortRange": "8082",
                        "access": "Allow",
                        "priority": 102,
                        "direction": "Inbound",
                        "sourceApplicationSecurityGroups": [
                            {
                                "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/applicationSecurityGroups/adp-<<namePrefix>>-az-asg-x-001"
                            }
                        ],
                        "destinationApplicationSecurityGroups": [
                            {
                                "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/applicationSecurityGroups/adp-<<namePrefix>>-az-asg-x-001"
                            }
                        ]
                    }
                }
            ]
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
        },
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "diagnosticStorageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "diagnosticWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module networkSecurityGroups './Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-networkSecurityGroups'
  params: {
    name: '<<namePrefix>>-az-nsg-x-001'
    lock: 'CanNotDelete'
    securityRules: [
      {
        name: 'Specific'
        properties: {
          description: 'Tests specific IPs and ports'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '8080'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Ranges'
        properties: {
          description: 'Tests Ranges'
          protocol: '*'
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
          sourcePortRanges: [
            '80'
            '81'
          ]
          destinationPortRanges: [
            '90'
            '91'
          ]
          sourceAddressPrefixes: [
            '10.0.0.0/16'
            '10.1.0.0/16'
          ]
          destinationAddressPrefixes: [
            '10.2.0.0/16'
            '10.3.0.0/16'
          ]
        }
      }
      {
        name: 'Port_8082'
        properties: {
          description: 'Allow inbound access on TCP 8082'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '8082'
          access: 'Allow'
          priority: 102
          direction: 'Inbound'
          sourceApplicationSecurityGroups: [
            {
              id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/applicationSecurityGroups/adp-<<namePrefix>>-az-asg-x-001'
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/applicationSecurityGroups/adp-<<namePrefix>>-az-asg-x-001'
            }
          ]
        }
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
  }
}
```

</details>
<p>

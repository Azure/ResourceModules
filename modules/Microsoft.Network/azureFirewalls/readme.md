# Azure Firewalls `[Microsoft.Network/azureFirewalls]`

This module deploys a firewall.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Considerations](#Considerations)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/azureFirewalls` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/azureFirewalls) |
| `Microsoft.Network/publicIPAddresses` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/publicIPAddresses) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Azure Firewall. |
| `vNetId` | string | Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a public ip is not provided, then the public ip that is created as part of this module will be applied with the subnet provided in this variable. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalPublicIpConfigurations` | array | `[]` |  | This is to add any additional public ip configurations on top of the public ip with subnet ip configuration. |
| `applicationRuleCollections` | array | `[]` |  | Collection of application rule collections used by Azure Firewall. |
| `azureFirewallSubnetPublicIpId` | string | `''` |  | The public ip resource ID to associate to the AzureFirewallSubnet. If empty, then the public ip that is created as part of this module will be applied to the AzureFirewallSubnet. |
| `azureSkuName` | string | `'AZFW_VNet'` | `[AZFW_VNet, AZFW_Hub]` | Name of an Azure Firewall SKU. |
| `azureSkuTier` | string | `'Standard'` | `[Standard, Premium]` | Tier of an Azure Firewall. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy]` | `[AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy]` | The name of firewall logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Diagnostic Storage Account resource identifier. |
| `diagnosticWorkspaceId` | string | `''` |  | Log Analytics workspace resource identifier. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `firewallPolicyId` | string | `''` |  | Resource ID of the Firewall Policy that should be attached. |
| `isCreateDefaultPublicIP` | bool | `True` |  | Specifies if a public ip should be created by default if one is not provided. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `natRuleCollections` | array | `[]` |  | Collection of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | `[]` |  | Collection of network rule collections used by Azure Firewall. |
| `publicIPAddressObject` | object | `{object}` |  | Specifies the properties of the public IP to create and be used by Azure Firewall. If it's not provided and publicIPAddressId is empty, a '-pip' suffix will be appended to the Firewall's name. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the Azure Firewall resource. |
| `threatIntelMode` | string | `'Deny'` | `[Alert, Deny, Off]` | The operation mode for Threat Intel. |
| `zones` | array | `[1, 2, 3]` |  | Zone numbers e.g. 1,2,3. |


### Parameter Usage: `additionalPublicIpConfigurations`

Create additional public ip configurations from existing public ips

<details>

<summary>Parameter JSON format</summary>

```json
"additionalPublicIpConfigurations": {
    "value": [
        {
            "name": "ipConfig01",
            "publicIPAddressResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-fw-01"
        },
        {
            "name": "ipConfig02",
            "publicIPAddressResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-fw-02"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
additionalPublicIpConfigurations: [
    {
        name: 'ipConfig01'
        publicIPAddressResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-fw-01'
    }
    {
        name: 'ipConfig02'
        publicIPAddressResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-fw-02'
    }
]
```

</details>


### Parameter Usage: `publicIPAddressObject`

The Public IP Address object to create as part of the module. This will be created if `isCreateDefaultPublicIP` is true (which it is by default). If not provided, the name and other configurations will be set by default.


<details>

<summary>Parameter JSON format</summary>

```json
"publicIPAddressObject": {
    "value": {
        "name": "adp-<<namePrefix>>-az-pip-custom-x-fw",
        "publicIPPrefixResourceId": "",
        "publicIPAllocationMethod": "Static",
        "skuName": "Standard",
        "skuTier": "Regional",
        "roleAssignments": [
            {
                "roleDefinitionIdOrName": "Reader",
                "principalIds": [
                    "<<deploymentSpId>>"
                ]
            }
        ],
        "diagnosticMetricsToEnable": [
            "AllMetrics"
        ],
        "diagnosticLogCategoriesToEnable": [
            "DDoSProtectionNotifications",
            "DDoSMitigationFlowLogs",
            "DDoSMitigationReports"
        ]
    }
}
```

</details>



<details>

<summary>Bicep format</summary>


```bicep
publicIPAddressObject: {
    name: 'mypip'
    publicIPPrefixResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPPrefixes/myprefix'
    publicIPAllocationMethod: 'Dynamic'
    skuName: 'Basic'
    skuTier: 'Regional'
    roleAssignments: [
        {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
                '<<deploymentSpId>>'
            ]
        }
    ]
    diagnosticMetricsToEnable: [
        'AllMetrics'
    ]
    diagnosticLogCategoriesToEnable: [
        'DDoSProtectionNotifications'
        'DDoSMitigationFlowLogs'
        'DDoSMitigationReports'
    ]
}
```

</details>


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
| `applicationRuleCollections` | array | List of Application Rule Collections. |
| `ipConfAzureFirewallSubnet` | object | The public ipconfiguration object for the AzureFirewallSubnet. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Azure firewall. |
| `natRuleCollections` | array | Collection of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | List of Network Rule Collections. |
| `privateIp` | string | The private IP of the Azure firewall. |
| `resourceGroupName` | string | The resource group the Azure firewall was deployed into. |
| `resourceId` | string | The resource ID of the Azure firewall. |

## Considerations

The `applicationRuleCollections` parameter accepts a JSON Array of AzureFirewallApplicationRule objects.
The `networkRuleCollections` parameter accepts a JSON Array of AzureFirewallNetworkRuleCollection objects.

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
            "value": "<<namePrefix>>-az-fw-add-001"
        },
        "vNetId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-add-azfw"
        },
        "additionalPublicIpConfigurations": {
            "value": [
                {
                    "name": "ipConfig01",
                    "publicIPAddressResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-additional-fw"
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
module azureFirewalls './Microsoft.Network/azureFirewalls/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-azureFirewalls'
  params: {
    name: '<<namePrefix>>-az-fw-add-001'
    vNetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-add-azfw'
    additionalPublicIpConfigurations: [
      {
        name: 'ipConfig01'
        publicIPAddressResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-additional-fw'
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
            "value": "<<namePrefix>>-az-fw-custompip-001"
        },
        "vNetId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-custompip-azfw"
        },
        "publicIPAddressObject": {
            "value": {
                "name": "adp-<<namePrefix>>-az-pip-custom-x-fw",
                "publicIPPrefixResourceId": "",
                "publicIPAllocationMethod": "Static",
                "skuName": "Standard",
                "skuTier": "Regional",
                "roleAssignments": [
                    {
                        "roleDefinitionIdOrName": "Reader",
                        "principalIds": [
                            "<<deploymentSpId>>"
                        ]
                    }
                ],
                "diagnosticMetricsToEnable": [
                    "AllMetrics"
                ],
                "diagnosticLogCategoriesToEnable": [
                    "DDoSProtectionNotifications",
                    "DDoSMitigationFlowLogs",
                    "DDoSMitigationReports"
                ]
            }
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewalls './Microsoft.Network/azureFirewalls/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-azureFirewalls'
  params: {
    name: '<<namePrefix>>-az-fw-custompip-001'
    vNetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-custompip-azfw'
    publicIPAddressObject: {
      name: 'adp-<<namePrefix>>-az-pip-custom-x-fw'
      publicIPPrefixResourceId: ''
      publicIPAllocationMethod: 'Static'
      skuName: 'Standard'
      skuTier: 'Regional'
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Reader'
          principalIds: [
            '<<deploymentSpId>>'
          ]
        }
      ]
      diagnosticMetricsToEnable: [
        'AllMetrics'
      ]
      diagnosticLogCategoriesToEnable: [
        'DDoSProtectionNotifications'
        'DDoSMitigationFlowLogs'
        'DDoSMitigationReports'
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 3</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-fw-min-001"
        },
        "vNetId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-min-azfw"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewalls './Microsoft.Network/azureFirewalls/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-azureFirewalls'
  params: {
    name: '<<namePrefix>>-az-fw-min-001'
    vNetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-min-azfw'
  }
}
```

</details>
<p>

<h3>Example 4</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-fw-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "zones": {
            "value": [
                "1",
                "2",
                "3"
            ]
        },
        "vNetId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-azfw"
        },
        "azureFirewallSubnetPublicIpId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-fw"
        },
        "applicationRuleCollections": {
            "value": [
                {
                    "name": "allow-app-rules",
                    "properties": {
                        "priority": 100,
                        "action": {
                            "type": "allow"
                        },
                        "rules": [
                            {
                                "name": "allow-ase-tags",
                                "sourceAddresses": [
                                    "*"
                                ],
                                "protocols": [
                                    {
                                        "protocolType": "HTTP",
                                        "port": "80"
                                    },
                                    {
                                        "protocolType": "HTTPS",
                                        "port": "443"
                                    }
                                ],
                                "fqdnTags": [
                                    "AppServiceEnvironment",
                                    "WindowsUpdate"
                                ]
                            },
                            {
                                "name": "allow-ase-management",
                                "sourceAddresses": [
                                    "*"
                                ],
                                "protocols": [
                                    {
                                        "protocolType": "HTTP",
                                        "port": "80"
                                    },
                                    {
                                        "protocolType": "HTTPS",
                                        "port": "443"
                                    }
                                ],
                                "targetFqdns": [
                                    "management.azure.com"
                                ]
                            }
                        ]
                    }
                }
            ]
        },
        "networkRuleCollections": {
            "value": [
                {
                    "name": "allow-network-rules",
                    "properties": {
                        "priority": 100,
                        "action": {
                            "type": "allow"
                        },
                        "rules": [
                            {
                                "name": "allow-ntp",
                                "sourceAddresses": [
                                    "*"
                                ],
                                "destinationAddresses": [
                                    "*"
                                ],
                                "destinationPorts": [
                                    "123",
                                    "12000"
                                ],
                                "protocols": [
                                    "Any"
                                ]
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
module azureFirewalls './Microsoft.Network/azureFirewalls/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-azureFirewalls'
  params: {
    name: '<<namePrefix>>-az-fw-x-001'
    lock: 'CanNotDelete'
    zones: [
      '1'
      '2'
      '3'
    ]
    vNetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-azfw'
    azureFirewallSubnetPublicIpId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-fw'
    applicationRuleCollections: [
      {
        name: 'allow-app-rules'
        properties: {
          priority: 100
          action: {
            type: 'allow'
          }
          rules: [
            {
              name: 'allow-ase-tags'
              sourceAddresses: [
                '*'
              ]
              protocols: [
                {
                  protocolType: 'HTTP'
                  port: '80'
                }
                {
                  protocolType: 'HTTPS'
                  port: '443'
                }
              ]
              fqdnTags: [
                'AppServiceEnvironment'
                'WindowsUpdate'
              ]
            }
            {
              name: 'allow-ase-management'
              sourceAddresses: [
                '*'
              ]
              protocols: [
                {
                  protocolType: 'HTTP'
                  port: '80'
                }
                {
                  protocolType: 'HTTPS'
                  port: '443'
                }
              ]
              targetFqdns: [
                'management.azure.com'
              ]
            }
          ]
        }
      }
    ]
    networkRuleCollections: [
      {
        name: 'allow-network-rules'
        properties: {
          priority: 100
          action: {
            type: 'allow'
          }
          rules: [
            {
              name: 'allow-ntp'
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                '*'
              ]
              destinationPorts: [
                '123'
                '12000'
              ]
              protocols: [
                'Any'
              ]
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

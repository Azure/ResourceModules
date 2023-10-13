# Azure Firewalls `[Microsoft.Network/azureFirewalls]`

This module deploys an Azure Firewall.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/azureFirewalls` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/azureFirewalls) |
| `Microsoft.Network/publicIPAddresses` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/publicIPAddresses) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Azure Firewall. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `hubIPAddresses` | object | `{object}` | IP addresses associated with AzureFirewall. Required if `virtualHubId` is supplied. |
| `virtualHubId` | string | `''` | The virtualHub resource ID to which the firewall belongs. Required if `vNetId` is empty. |
| `vNetId` | string | `''` | Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a Public IP is not provided, then the Public IP that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalPublicIpConfigurations` | array | `[]` |  | This is to add any additional Public IP configurations on top of the Public IP with subnet IP configuration. |
| `applicationRuleCollections` | array | `[]` |  | Collection of application rule collections used by Azure Firewall. |
| `azureSkuTier` | string | `'Standard'` | `[Basic, Premium, Standard]` | Tier of an Azure Firewall. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, AzureFirewallApplicationRule, AzureFirewallDnsProxy, AzureFirewallNetworkRule]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Diagnostic Storage Account resource identifier. |
| `diagnosticWorkspaceId` | string | `''` |  | Log Analytics workspace resource identifier. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `firewallPolicyId` | string | `''` |  | Resource ID of the Firewall Policy that should be attached. |
| `isCreateDefaultPublicIP` | bool | `True` |  | Specifies if a Public IP should be created by default if one is not provided. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `managementIPAddressObject` | object | `{object}` |  | Specifies the properties of the Management Public IP to create and be used by Azure Firewall. If it's not provided and managementIPResourceID is empty, a '-mip' suffix will be appended to the Firewall's name. |
| `managementIPResourceID` | string | `''` |  | The Management Public IP resource ID to associate to the AzureFirewallManagementSubnet. If empty, then the Management Public IP that is created as part of this module will be applied to the AzureFirewallManagementSubnet. |
| `natRuleCollections` | array | `[]` |  | Collection of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | `[]` |  | Collection of network rule collections used by Azure Firewall. |
| `publicIPAddressObject` | object | `{object}` |  | Specifies the properties of the Public IP to create and be used by Azure Firewall. If it's not provided and publicIPResourceID is empty, a '-pip' suffix will be appended to the Firewall's name. |
| `publicIPResourceID` | string | `''` |  | The Public IP resource ID to associate to the AzureFirewallSubnet. If empty, then the Public IP that is created as part of this module will be applied to the AzureFirewallSubnet. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the Azure Firewall resource. |
| `threatIntelMode` | string | `'Deny'` | `[Alert, Deny, Off]` | The operation mode for Threat Intel. |
| `zones` | array | `[1, 2, 3]` |  | Zone numbers e.g. 1,2,3. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `applicationRuleCollections` | array | List of Application Rule Collections. |
| `ipConfAzureFirewallSubnet` | object | The Public IP configuration object for the Azure Firewall Subnet. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Azure Firewall. |
| `natRuleCollections` | array | Collection of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | List of Network Rule Collections. |
| `privateIp` | string | The private IP of the Azure firewall. |
| `resourceGroupName` | string | The resource group the Azure firewall was deployed into. |
| `resourceId` | string | The resource ID of the Azure Firewall. |


## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/public-ip-address` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Addpip</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall './network/azure-firewall/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafaddpip'
  params: {
    // Required parameters
    name: 'nafaddpip001'
    // Non-required parameters
    additionalPublicIpConfigurations: [
      {
        name: 'ipConfig01'
        publicIPAddressResourceId: '<publicIPAddressResourceId>'
      }
    ]
    azureSkuTier: 'Basic'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managementIPAddressObject: {
      publicIPAllocationMethod: 'Static'
      roleAssignments: [
        {
          principalIds: [
            '<managedIdentityPrincipalId>'
          ]
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Reader'
        }
      ]
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vNetId: '<vNetId>'
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
      "value": "nafaddpip001"
    },
    // Non-required parameters
    "additionalPublicIpConfigurations": {
      "value": [
        {
          "name": "ipConfig01",
          "publicIPAddressResourceId": "<publicIPAddressResourceId>"
        }
      ]
    },
    "azureSkuTier": {
      "value": "Basic"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managementIPAddressObject": {
      "value": {
        "publicIPAllocationMethod": "Static",
        "roleAssignments": [
          {
            "principalIds": [
              "<managedIdentityPrincipalId>"
            ],
            "principalType": "ServicePrincipal",
            "roleDefinitionIdOrName": "Reader"
          }
        ]
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vNetId": {
      "value": "<vNetId>"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall './network/azure-firewall/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafcom'
  params: {
    // Required parameters
    name: 'nafcom001'
    // Non-required parameters
    applicationRuleCollections: [
      {
        name: 'allow-app-rules'
        properties: {
          action: {
            type: 'allow'
          }
          priority: 100
          rules: [
            {
              fqdnTags: [
                'AppServiceEnvironment'
                'WindowsUpdate'
              ]
              name: 'allow-ase-tags'
              protocols: [
                {
                  port: '80'
                  protocolType: 'HTTP'
                }
                {
                  port: '443'
                  protocolType: 'HTTPS'
                }
              ]
              sourceAddresses: [
                '*'
              ]
            }
            {
              name: 'allow-ase-management'
              protocols: [
                {
                  port: '80'
                  protocolType: 'HTTP'
                }
                {
                  port: '443'
                  protocolType: 'HTTPS'
                }
              ]
              sourceAddresses: [
                '*'
              ]
              targetFqdns: [
                'bing.com'
              ]
            }
          ]
        }
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    networkRuleCollections: [
      {
        name: 'allow-network-rules'
        properties: {
          action: {
            type: 'allow'
          }
          priority: 100
          rules: [
            {
              destinationAddresses: [
                '*'
              ]
              destinationPorts: [
                '12000'
                '123'
              ]
              name: 'allow-ntp'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
            }
          ]
        }
      }
    ]
    publicIPResourceID: '<publicIPResourceID>'
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
    vNetId: '<vNetId>'
    zones: [
      '1'
      '2'
      '3'
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
    // Required parameters
    "name": {
      "value": "nafcom001"
    },
    // Non-required parameters
    "applicationRuleCollections": {
      "value": [
        {
          "name": "allow-app-rules",
          "properties": {
            "action": {
              "type": "allow"
            },
            "priority": 100,
            "rules": [
              {
                "fqdnTags": [
                  "AppServiceEnvironment",
                  "WindowsUpdate"
                ],
                "name": "allow-ase-tags",
                "protocols": [
                  {
                    "port": "80",
                    "protocolType": "HTTP"
                  },
                  {
                    "port": "443",
                    "protocolType": "HTTPS"
                  }
                ],
                "sourceAddresses": [
                  "*"
                ]
              },
              {
                "name": "allow-ase-management",
                "protocols": [
                  {
                    "port": "80",
                    "protocolType": "HTTP"
                  },
                  {
                    "port": "443",
                    "protocolType": "HTTPS"
                  }
                ],
                "sourceAddresses": [
                  "*"
                ],
                "targetFqdns": [
                  "bing.com"
                ]
              }
            ]
          }
        }
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "networkRuleCollections": {
      "value": [
        {
          "name": "allow-network-rules",
          "properties": {
            "action": {
              "type": "allow"
            },
            "priority": 100,
            "rules": [
              {
                "destinationAddresses": [
                  "*"
                ],
                "destinationPorts": [
                  "12000",
                  "123"
                ],
                "name": "allow-ntp",
                "protocols": [
                  "Any"
                ],
                "sourceAddresses": [
                  "*"
                ]
              }
            ]
          }
        }
      ]
    },
    "publicIPResourceID": {
      "value": "<publicIPResourceID>"
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
    },
    "vNetId": {
      "value": "<vNetId>"
    },
    "zones": {
      "value": [
        "1",
        "2",
        "3"
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 3: Custompip</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall './network/azure-firewall/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafcstpip'
  params: {
    // Required parameters
    name: 'nafcstpip001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    publicIPAddressObject: {
      diagnosticLogCategoriesToEnable: [
        'DDoSMitigationFlowLogs'
        'DDoSMitigationReports'
        'DDoSProtectionNotifications'
      ]
      diagnosticMetricsToEnable: [
        'AllMetrics'
      ]
      name: 'new-pip-nafcstpip'
      publicIPAllocationMethod: 'Static'
      publicIPPrefixResourceId: ''
      roleAssignments: [
        {
          principalIds: [
            '<managedIdentityPrincipalId>'
          ]
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Reader'
        }
      ]
      skuName: 'Standard'
      skuTier: 'Regional'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vNetId: '<vNetId>'
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
      "value": "nafcstpip001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "publicIPAddressObject": {
      "value": {
        "diagnosticLogCategoriesToEnable": [
          "DDoSMitigationFlowLogs",
          "DDoSMitigationReports",
          "DDoSProtectionNotifications"
        ],
        "diagnosticMetricsToEnable": [
          "AllMetrics"
        ],
        "name": "new-pip-nafcstpip",
        "publicIPAllocationMethod": "Static",
        "publicIPPrefixResourceId": "",
        "roleAssignments": [
          {
            "principalIds": [
              "<managedIdentityPrincipalId>"
            ],
            "principalType": "ServicePrincipal",
            "roleDefinitionIdOrName": "Reader"
          }
        ],
        "skuName": "Standard",
        "skuTier": "Regional"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vNetId": {
      "value": "<vNetId>"
    }
  }
}
```

</details>
<p>

<h3>Example 4: Hubcommon</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall './network/azure-firewall/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafhubcom'
  params: {
    // Required parameters
    name: 'nafhubcom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    firewallPolicyId: '<firewallPolicyId>'
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualHubId: '<virtualHubId>'
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
      "value": "nafhubcom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "firewallPolicyId": {
      "value": "<firewallPolicyId>"
    },
    "hubIPAddresses": {
      "value": {
        "publicIPs": {
          "count": 1
        }
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "virtualHubId": {
      "value": "<virtualHubId>"
    }
  }
}
```

</details>
<p>

<h3>Example 5: Hubmin</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall './network/azure-firewall/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafhubmin'
  params: {
    // Required parameters
    name: 'nafhubmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    virtualHubId: '<virtualHubId>'
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
      "value": "nafhubmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "hubIPAddresses": {
      "value": {
        "publicIPs": {
          "count": 1
        }
      }
    },
    "virtualHubId": {
      "value": "<virtualHubId>"
    }
  }
}
```

</details>
<p>

<h3>Example 6: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall './network/azure-firewall/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nafmin'
  params: {
    // Required parameters
    name: 'nafmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    vNetId: '<vNetId>'
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
      "value": "nafmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "vNetId": {
      "value": "<vNetId>"
    }
  }
}
```

</details>
<p>

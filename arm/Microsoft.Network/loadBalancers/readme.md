# Load Balancers `[Microsoft.Network/loadBalancers]`

This module deploys a load balancer.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/loadBalancers` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/loadBalancers) |
| `Microsoft.Network/loadBalancers/backendAddressPools` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/loadBalancers/backendAddressPools) |
| `Microsoft.Network/loadBalancers/inboundNatRules` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/loadBalancers/inboundNatRules) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `frontendIPConfigurations` | array | Array of objects containing all frontend IP configurations. |
| `name` | string | The Proximity Placement Groups Name. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backendAddressPools` | _[backendAddressPools](backendAddressPools/readme.md)_ array | `[]` |  | Collection of backend address pools used by a load balancer. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `inboundNatRules` | _[inboundNatRules](inboundNatRules/readme.md)_ array | `[]` |  | Collection of inbound NAT Rules used by a load balancer. Defining inbound NAT rules on your load balancer is mutually exclusive with defining an inbound NAT pool. Inbound NAT pools are referenced from virtual machine scale sets. NICs that are associated with individual virtual machines cannot reference an Inbound NAT pool. They have to reference individual inbound NAT rules. |
| `loadBalancerSku` | string | `'Standard'` | `[Basic, Standard]` | Name of a load balancer SKU. |
| `loadBalancingRules` | array | `[]` |  | Array of objects containing all load balancing rules. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `outboundRules` | array | `[]` |  | The outbound rules. |
| `probes` | array | `[]` |  | Array of objects containing all probes, these are references in the load balancing rules. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |


### Parameter Usage: `frontendIPConfigurations`

<details>

<summary>Parameter JSON format</summary>

```json
"frontendIPConfigurations": {
    "value": [
        {
            "name": "p_hub-bfw-server-feip",
            "properties": {
                "publicIPAddressId": "[reference(variables('deploymentPIP-VPN')).outputs.publicIPAddressResourceId.value]",
                "subnetId": "",
                "privateIPAddress": ""
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
frontendIPConfigurations: [
    {
        name: 'p_hub-bfw-server-feip'
        properties: {
            publicIPAddressId: '[reference(variables('deploymentPIP-VPN')).outputs.publicIPAddressResourceId.value]'
            subnetId: ''
            privateIPAddress: ''
        }
    }
]
```

</details>
<p>

### Parameter Usage: `backendAddressPools`

<details>

<summary>Parameter JSON format</summary>

```json
"backendAddressPools": {
    "value": [
        {
            "name": "p_hub-bfw-server-bepool",
            "properties": {
                "loadBalancerBackendAddresses": [
                    {
                        "name": "iacs-sh-main-pd-01-euw-rg-network_awefwa01p-nic-int-01ipconfig-internal",
                        "properties": {
                            "virtualNetwork": {
                                "id": "[reference(variables('deploymentVNET')).outputs.vNetResourceId.value]"
                            },
                            "ipAddress": "172.22.232.5"
                        }
                    },
                    {
                        "name": "iacs-sh-main-pd-01-euw-rg-network_awefwa01p-ha-nic-int-01ipconfig-internal",
                        "properties": {
                            "virtualNetwork": {
                                "id": "[reference(variables('deploymentVNET')).outputs.vNetResourceId.value]"
                            },
                            "ipAddress": "172.22.232.6"
                        }
                    }
                ]
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
backendAddressPools: [
    {
        name: 'p_hub-bfw-server-bepool'
        properties: {
            loadBalancerBackendAddresses: [
                {
                    name: 'iacs-sh-main-pd-01-euw-rg-network_awefwa01p-nic-int-01ipconfig-internal'
                    properties: {
                        virtualNetwork: {
                            id: '[reference(variables('deploymentVNET')).outputs.vNetResourceId.value]'
                        }
                        ipAddress: '172.22.232.5'
                    }
                }
                {
                    name: 'iacs-sh-main-pd-01-euw-rg-network_awefwa01p-ha-nic-int-01ipconfig-internal'
                    properties: {
                        virtualNetwork: {
                            id: '[reference(variables('deploymentVNET')).outputs.vNetResourceId.value]'
                        }
                        ipAddress: '172.22.232.6'
                    }
                }
            ]
        }
    }
]
```

</details>
<p>

### Parameter Usage: `loadBalancingRules`

<details>

<summary>Parameter JSON format</summary>

```json
"loadBalancingRules": {
    "value": [
        {
            "name": "p_hub-bfw-server-IPSEC-IKE-lbrule",
            "properties": {
                "frontendIPConfigurationName": "p_hub-bfw-server-feip",
                "backendAddressPoolName": "p_hub-bfw-server-bepool",
                "protocol": "Udp",
                "frontendPort": 500,
                "backendPort": 500,
                "enableFloatingIP": false,
                "idleTimeoutInMinutes": 5,
                "probeName": "p_hub-bfw-server-tcp-65001-probe"
            }
        },
        {
            "name": "p_hub-bfw-server-IPSEC-NATT-lbrule",
            "properties": {
                "frontendIPConfigurationName": "p_hub-bfw-server-feip",
                "backendAddressPoolName": "p_hub-bfw-server-bepool",
                "protocol": "Udp",
                "frontendPort": 4500,
                "backendPort": 4500,
                "enableFloatingIP": false,
                "idleTimeoutInMinutes": 5,
                "probeName": "p_hub-bfw-server-tcp-65001-probe"
            }
        },
        {
            "name": "p_hub-bfw-server-TINA-UDP-lbrule",
            "properties": {
                "frontendIPConfigurationName": "p_hub-bfw-server-feip",
                "backendAddressPoolName": "p_hub-bfw-server-bepool",
                "protocol": "Udp",
                "frontendPort": 691,
                "backendPort": 691,
                "enableFloatingIP": false,
                "idleTimeoutInMinutes": 5,
                "probeName": "p_hub-bfw-server-tcp-65001-probe"
            }
        },
        {
            "name": "p_hub-bfw-server-TINA-TCP-lbrule",
            "properties": {
                "frontendIPConfigurationName": "p_hub-bfw-server-feip",
                "backendAddressPoolName": "p_hub-bfw-server-bepool",
                "protocol": "Tcp",
                "frontendPort": 691,
                "backendPort": 691,
                "enableFloatingIP": false,
                "idleTimeoutInMinutes": 5,
                "probeName": "p_hub-bfw-server-tcp-65001-probe"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
loadBalancingRules: [
    {
        name: 'p_hub-bfw-server-IPSEC-IKE-lbrule'
        properties: {
            frontendIPConfigurationName: 'p_hub-bfw-server-feip'
            backendAddressPoolName: 'p_hub-bfw-server-bepool'
            protocol: 'Udp'
            frontendPort: 500
            backendPort: 500
            enableFloatingIP: false
            idleTimeoutInMinutes: 5
            probeName: 'p_hub-bfw-server-tcp-65001-probe'
        }
    }
    {
        name: 'p_hub-bfw-server-IPSEC-NATT-lbrule'
        properties: {
            frontendIPConfigurationName: 'p_hub-bfw-server-feip'
            backendAddressPoolName: 'p_hub-bfw-server-bepool'
            protocol: 'Udp'
            frontendPort: 4500
            backendPort: 4500
            enableFloatingIP: false
            idleTimeoutInMinutes: 5
            probeName: 'p_hub-bfw-server-tcp-65001-probe'
        }
    }
    {
        name: 'p_hub-bfw-server-TINA-UDP-lbrule'
        properties: {
            frontendIPConfigurationName: 'p_hub-bfw-server-feip'
            backendAddressPoolName: 'p_hub-bfw-server-bepool'
            protocol: 'Udp'
            frontendPort: 691
            backendPort: 691
            enableFloatingIP: false
            idleTimeoutInMinutes: 5
            probeName: 'p_hub-bfw-server-tcp-65001-probe'
        }
    }
    {
        name: 'p_hub-bfw-server-TINA-TCP-lbrule'
        properties: {
            frontendIPConfigurationName: 'p_hub-bfw-server-feip'
            backendAddressPoolName: 'p_hub-bfw-server-bepool'
            protocol: 'Tcp'
            frontendPort: 691
            backendPort: 691
            enableFloatingIP: false
            idleTimeoutInMinutes: 5
            probeName: 'p_hub-bfw-server-tcp-65001-probe'
        }
    }
]
```

</details>
<p>

### Parameter Usage: `probes`

<details>

<summary>Parameter JSON format</summary>

```json
"probes": {
    "value": [
        {
            "name": "p_hub-bfw-server-tcp-65001-probe",
            "properties": {
                "protocol": "Tcp",
                "port": 65001,
                "intervalInSeconds": 5,
                "numberOfProbes": 2
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
probes: [
    {
        name: 'p_hub-bfw-server-tcp-65001-probe'
        properties: {
            protocol: 'Tcp'
            port: 65001
            intervalInSeconds: 5
            numberOfProbes: 2
        }
    }
]
```

</details>
<p>

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
| `backendpools` | array | The backend address pools available in the load balancer. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the load balancer. |
| `resourceGroupName` | string | The resource group the load balancer was deployed into. |
| `resourceId` | string | The resource ID of the load balancer. |

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
            "value": "<<namePrefix>>-az-lb-internal-001"
        },
        "loadBalancerSku": {
            "value": "Standard"
        },
        "frontendIPConfigurations": {
            "value": [
                {
                    "name": "privateIPConfig1",
                    "subnetId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001"
                }
            ]
        },
        "backendAddressPools": {
            "value": [
                {
                    "name": "servers"
                }
            ]
        },
        "probes": {
            "value": [
                {
                    "name": "probe1",
                    "protocol": "Tcp",
                    "port": "62000",
                    "intervalInSeconds": 5,
                    "numberOfProbes": 2
                }
            ]
        },
        "loadBalancingRules": {
            "value": [
                {
                    "name": "privateIPLBRule1",
                    "frontendIPConfigurationName": "privateIPConfig1",
                    "frontendPort": 0,
                    "backendPort": 0,
                    "enableFloatingIP": true,
                    "idleTimeoutInMinutes": 4,
                    "protocol": "All",
                    "loadDistribution": "Default",
                    "probeName": "probe1",
                    "disableOutboundSnat": true,
                    "enableTcpReset": false,
                    "backendAddressPoolName": "servers"
                }
            ]
        },
        "inboundNatRules": {
            "value": [
                {
                    "name": "inboundNatRule1",
                    "frontendIPConfigurationName": "privateIPConfig1",
                    "frontendPort": 443,
                    "backendPort": 443,
                    "enableFloatingIP": false,
                    "idleTimeoutInMinutes": 4,
                    "protocol": "Tcp",
                    "enableTcpReset": false
                },
                {
                    "name": "inboundNatRule2",
                    "frontendIPConfigurationName": "privateIPConfig1",
                    "frontendPort": 3389,
                    "backendPort": 3389
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
module loadBalancers './Microsoft.Network/loadBalancers/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-loadBalancers'
  params: {
    name: '<<namePrefix>>-az-lb-internal-001'
    loadBalancerSku: 'Standard'
    frontendIPConfigurations: [
      {
        name: 'privateIPConfig1'
        subnetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
      }
    ]
    backendAddressPools: [
      {
        name: 'servers'
      }
    ]
    probes: [
      {
        name: 'probe1'
        protocol: 'Tcp'
        port: '62000'
        intervalInSeconds: 5
        numberOfProbes: 2
      }
    ]
    loadBalancingRules: [
      {
        name: 'privateIPLBRule1'
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 0
        backendPort: 0
        enableFloatingIP: true
        idleTimeoutInMinutes: 4
        protocol: 'All'
        loadDistribution: 'Default'
        probeName: 'probe1'
        disableOutboundSnat: true
        enableTcpReset: false
        backendAddressPoolName: 'servers'
      }
    ]
    inboundNatRules: [
      {
        name: 'inboundNatRule1'
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 443
        backendPort: 443
        enableFloatingIP: false
        idleTimeoutInMinutes: 4
        protocol: 'Tcp'
        enableTcpReset: false
      }
      {
        name: 'inboundNatRule2'
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 3389
        backendPort: 3389
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

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-lb-min-001"
        },
        "frontendIPConfigurations": {
            "value": [
                {
                    "name": "publicIPConfig1",
                    "publicIPAddressId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-min-lb"
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
module loadBalancers './Microsoft.Network/loadBalancers/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-loadBalancers'
  params: {
    name: '<<namePrefix>>-az-lb-min-001'
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-min-lb'
      }
    ]
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
            "value": "<<namePrefix>>-az-lb-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "frontendIPConfigurations": {
            "value": [
                {
                    "name": "publicIPConfig1",
                    "publicIPAddressId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-lb"
                }
            ]
        },
        "backendAddressPools": {
            "value": [
                {
                    "name": "backendAddressPool1"
                },
                {
                    "name": "backendAddressPool2"
                }
            ]
        },
        "loadBalancingRules": {
            "value": [
                {
                    "name": "publicIPLBRule1",
                    "frontendIPConfigurationName": "publicIPConfig1",
                    "frontendPort": 80,
                    "backendPort": 80,
                    "enableFloatingIP": false,
                    "idleTimeoutInMinutes": 5,
                    "protocol": "Tcp",
                    "enableTcpReset": false,
                    "loadDistribution": "Default",
                    "disableOutboundSnat": true,
                    "probeName": "probe1",
                    "backendAddressPoolName": "backendAddressPool1"
                },
                {
                    "name": "publicIPLBRule2",
                    "frontendIPConfigurationName": "publicIPConfig1",
                    "frontendPort": 8080,
                    "backendPort": 8080,
                    "loadDistribution": "Default",
                    "probeName": "probe2",
                    "backendAddressPoolName": "backendAddressPool2"
                }
            ]
        },
        "inboundNatRules": {
            "value": [
                {
                    "name": "inboundNatRule1",
                    "frontendIPConfigurationName": "publicIPConfig1",
                    "frontendPort": 443,
                    "backendPort": 443,
                    "enableFloatingIP": false,
                    "idleTimeoutInMinutes": 4,
                    "protocol": "Tcp",
                    "enableTcpReset": false
                },
                {
                    "name": "inboundNatRule2",
                    "frontendIPConfigurationName": "publicIPConfig1",
                    "frontendPort": 3389,
                    "backendPort": 3389
                }
            ]
        },
        "outboundRules": {
            "value": [
                {
                    "name": "outboundRule1",
                    "frontendIPConfigurationName": "publicIPConfig1",
                    "backendAddressPoolName": "backendAddressPool1",
                    "allocatedOutboundPorts": 63984
                }
            ]
        },
        "probes": {
            "value": [
                {
                    "name": "probe1",
                    "protocol": "Tcp",
                    "port": 80,
                    "intervalInSeconds": 10,
                    "numberOfProbes": 5
                },
                {
                    "name": "probe2",
                    "protocol": "Https",
                    "port": 443,
                    "requestPath": "/"
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
module loadBalancers './Microsoft.Network/loadBalancers/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-loadBalancers'
  params: {
    name: '<<namePrefix>>-az-lb-x-001'
    lock: 'CanNotDelete'
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/publicIPAddresses/adp-<<namePrefix>>-az-pip-x-lb'
      }
    ]
    backendAddressPools: [
      {
        name: 'backendAddressPool1'
      }
      {
        name: 'backendAddressPool2'
      }
    ]
    loadBalancingRules: [
      {
        name: 'publicIPLBRule1'
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 80
        backendPort: 80
        enableFloatingIP: false
        idleTimeoutInMinutes: 5
        protocol: 'Tcp'
        enableTcpReset: false
        loadDistribution: 'Default'
        disableOutboundSnat: true
        probeName: 'probe1'
        backendAddressPoolName: 'backendAddressPool1'
      }
      {
        name: 'publicIPLBRule2'
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 8080
        backendPort: 8080
        loadDistribution: 'Default'
        probeName: 'probe2'
        backendAddressPoolName: 'backendAddressPool2'
      }
    ]
    inboundNatRules: [
      {
        name: 'inboundNatRule1'
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 443
        backendPort: 443
        enableFloatingIP: false
        idleTimeoutInMinutes: 4
        protocol: 'Tcp'
        enableTcpReset: false
      }
      {
        name: 'inboundNatRule2'
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 3389
        backendPort: 3389
      }
    ]
    outboundRules: [
      {
        name: 'outboundRule1'
        frontendIPConfigurationName: 'publicIPConfig1'
        backendAddressPoolName: 'backendAddressPool1'
        allocatedOutboundPorts: 63984
      }
    ]
    probes: [
      {
        name: 'probe1'
        protocol: 'Tcp'
        port: 80
        intervalInSeconds: 10
        numberOfProbes: 5
      }
      {
        name: 'probe2'
        protocol: 'Https'
        port: 443
        requestPath: '/'
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

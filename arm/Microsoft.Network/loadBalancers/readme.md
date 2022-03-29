# Load Balancers `[Microsoft.Network/loadBalancers]`

This module deploys a load balancer.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/loadBalancers` | 2021-05-01 |
| `Microsoft.Network/loadBalancers/backendAddressPools` | 2021-05-01 |
| `Microsoft.Network/loadBalancers/inboundNatRules` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `frontendIPConfigurations` | array | Array of objects containing all frontend IP configurations |
| `name` | string | The Proximity Placement Groups Name |

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
| `loadBalancingRules` | array | `[]` |  | Array of objects containing all load balancing rules |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `outboundRules` | array | `[]` |  | The outbound rules. |
| `probes` | array | `[]` |  | Array of objects containing all probes, these are references in the load balancing rules |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Tags of the resource. |


### Parameter Usage: `frontendIPConfigurations`

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

### Parameter Usage: `backendAddressPools`

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

### Parameter Usage: `loadBalancingRules`

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

### Parameter Usage: `probes`

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

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

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

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `backendpools` | array | The backend address pools available in the load balancer. |
| `name` | string | The name of the load balancer |
| `resourceGroupName` | string | The resource group the load balancer was deployed into |
| `resourceId` | string | The resource ID of the load balancer |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Loadbalancers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/loadBalancers)
- [Loadbalancers/Backendaddresspools](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/loadBalancers/backendAddressPools)
- [Loadbalancers/Inboundnatrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/loadBalancers/inboundNatRules)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

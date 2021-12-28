# Load Balancers `[Microsoft.Network/loadBalancers]`

This module deploys a load balancer.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/loadBalancers` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backendAddressPools` | array |  |  | Required. Collection of backend address pools used by a load balancer. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `frontendIPConfigurations` | array |  |  | Required. Array of objects containing all frontend IP configurations |
| `loadBalancerSku` | string | `Standard` | `[Basic, Standard]` | Optional. Name of a load balancer SKU. |
| `loadBalancingRules` | array |  |  | Required. Array of objects containing all load balancing rules |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. The Proximity Placement Groups Name |
| `probes` | array |  |  | Required. Array of objects containing all probes, these are references in the load balancing rules |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics. |

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

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
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
| `loadBalancerName` | string | The name of the load balancer |
| `loadBalancerResourceGroup` | string | The resource group the load balancer was deployed into |
| `loadBalancerResourceId` | string | The resource ID of the load balancer |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Loadbalancers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/loadBalancers)

# Load Balancers `[Microsoft.Network/loadBalancers]`

This module deploys a Load Balancer.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)
- [Notes](#Notes)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/loadBalancers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/loadBalancers) |
| `Microsoft.Network/loadBalancers/backendAddressPools` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/loadBalancers/backendAddressPools) |
| `Microsoft.Network/loadBalancers/inboundNatRules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/loadBalancers/inboundNatRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `frontendIPConfigurations` | array | Array of objects containing all frontend IP configurations. |
| `name` | string | The Proximity Placement Groups Name. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backendAddressPools` | array | `[]` |  | Collection of backend address pools used by a load balancer. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `inboundNatRules` | array | `[]` |  | Collection of inbound NAT Rules used by a load balancer. Defining inbound NAT rules on your load balancer is mutually exclusive with defining an inbound NAT pool. Inbound NAT pools are referenced from virtual machine scale sets. NICs that are associated with individual virtual machines cannot reference an Inbound NAT pool. They have to reference individual inbound NAT rules. |
| `loadBalancingRules` | array | `[]` |  | Array of objects containing all load balancing rules. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `outboundRules` | array | `[]` |  | The outbound rules. |
| `probes` | array | `[]` |  | Array of objects containing all probes, these are references in the load balancing rules. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `skuName` | string | `'Standard'` | `[Basic, Standard]` | Name of a load balancer SKU. |
| `tags` | object | `{object}` |  | Tags of the resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `backendpools` | array | The backend address pools available in the load balancer. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the load balancer. |
| `resourceGroupName` | string | The resource group the load balancer was deployed into. |
| `resourceId` | string | The resource ID of the load balancer. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer './network/load-balancer/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nlbcom'
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressId: '<publicIPAddressId>'
      }
    ]
    name: 'nlbcom001'
    // Non-required parameters
    backendAddressPools: [
      {
        name: 'backendAddressPool1'
      }
      {
        name: 'backendAddressPool2'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    inboundNatRules: [
      {
        backendPort: 443
        enableFloatingIP: false
        enableTcpReset: false
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 443
        idleTimeoutInMinutes: 4
        name: 'inboundNatRule1'
        protocol: 'Tcp'
      }
      {
        backendPort: 3389
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 3389
        name: 'inboundNatRule2'
      }
    ]
    loadBalancingRules: [
      {
        backendAddressPoolName: 'backendAddressPool1'
        backendPort: 80
        disableOutboundSnat: true
        enableFloatingIP: false
        enableTcpReset: false
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 80
        idleTimeoutInMinutes: 5
        loadDistribution: 'Default'
        name: 'publicIPLBRule1'
        probeName: 'probe1'
        protocol: 'Tcp'
      }
      {
        backendAddressPoolName: 'backendAddressPool2'
        backendPort: 8080
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 8080
        loadDistribution: 'Default'
        name: 'publicIPLBRule2'
        probeName: 'probe2'
      }
    ]
    lock: 'CanNotDelete'
    outboundRules: [
      {
        allocatedOutboundPorts: 63984
        backendAddressPoolName: 'backendAddressPool1'
        frontendIPConfigurationName: 'publicIPConfig1'
        name: 'outboundRule1'
      }
    ]
    probes: [
      {
        intervalInSeconds: 10
        name: 'probe1'
        numberOfProbes: 5
        port: 80
        protocol: 'Tcp'
      }
      {
        name: 'probe2'
        port: 443
        protocol: 'Https'
        requestPath: '/'
      }
    ]
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
    // Required parameters
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "publicIPConfig1",
          "publicIPAddressId": "<publicIPAddressId>"
        }
      ]
    },
    "name": {
      "value": "nlbcom001"
    },
    // Non-required parameters
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
    "inboundNatRules": {
      "value": [
        {
          "backendPort": 443,
          "enableFloatingIP": false,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 443,
          "idleTimeoutInMinutes": 4,
          "name": "inboundNatRule1",
          "protocol": "Tcp"
        },
        {
          "backendPort": 3389,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 3389,
          "name": "inboundNatRule2"
        }
      ]
    },
    "loadBalancingRules": {
      "value": [
        {
          "backendAddressPoolName": "backendAddressPool1",
          "backendPort": 80,
          "disableOutboundSnat": true,
          "enableFloatingIP": false,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 80,
          "idleTimeoutInMinutes": 5,
          "loadDistribution": "Default",
          "name": "publicIPLBRule1",
          "probeName": "probe1",
          "protocol": "Tcp"
        },
        {
          "backendAddressPoolName": "backendAddressPool2",
          "backendPort": 8080,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 8080,
          "loadDistribution": "Default",
          "name": "publicIPLBRule2",
          "probeName": "probe2"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "outboundRules": {
      "value": [
        {
          "allocatedOutboundPorts": 63984,
          "backendAddressPoolName": "backendAddressPool1",
          "frontendIPConfigurationName": "publicIPConfig1",
          "name": "outboundRule1"
        }
      ]
    },
    "probes": {
      "value": [
        {
          "intervalInSeconds": 10,
          "name": "probe1",
          "numberOfProbes": 5,
          "port": 80,
          "protocol": "Tcp"
        },
        {
          "name": "probe2",
          "port": 443,
          "protocol": "Https",
          "requestPath": "/"
        }
      ]
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

<h3>Example 2: Internal</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer './network/load-balancer/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nlbint'
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'privateIPConfig1'
        subnetId: '<subnetId>'
      }
    ]
    name: 'nlbint001'
    // Non-required parameters
    backendAddressPools: [
      {
        name: 'servers'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    inboundNatRules: [
      {
        backendPort: 443
        enableFloatingIP: false
        enableTcpReset: false
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 443
        idleTimeoutInMinutes: 4
        name: 'inboundNatRule1'
        protocol: 'Tcp'
      }
      {
        backendPort: 3389
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 3389
        name: 'inboundNatRule2'
      }
    ]
    loadBalancingRules: [
      {
        backendAddressPoolName: 'servers'
        backendPort: 0
        disableOutboundSnat: true
        enableFloatingIP: true
        enableTcpReset: false
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 0
        idleTimeoutInMinutes: 4
        loadDistribution: 'Default'
        name: 'privateIPLBRule1'
        probeName: 'probe1'
        protocol: 'All'
      }
    ]
    probes: [
      {
        intervalInSeconds: 5
        name: 'probe1'
        numberOfProbes: 2
        port: '62000'
        protocol: 'Tcp'
      }
    ]
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
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "privateIPConfig1",
          "subnetId": "<subnetId>"
        }
      ]
    },
    "name": {
      "value": "nlbint001"
    },
    // Non-required parameters
    "backendAddressPools": {
      "value": [
        {
          "name": "servers"
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
    "inboundNatRules": {
      "value": [
        {
          "backendPort": 443,
          "enableFloatingIP": false,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "privateIPConfig1",
          "frontendPort": 443,
          "idleTimeoutInMinutes": 4,
          "name": "inboundNatRule1",
          "protocol": "Tcp"
        },
        {
          "backendPort": 3389,
          "frontendIPConfigurationName": "privateIPConfig1",
          "frontendPort": 3389,
          "name": "inboundNatRule2"
        }
      ]
    },
    "loadBalancingRules": {
      "value": [
        {
          "backendAddressPoolName": "servers",
          "backendPort": 0,
          "disableOutboundSnat": true,
          "enableFloatingIP": true,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "privateIPConfig1",
          "frontendPort": 0,
          "idleTimeoutInMinutes": 4,
          "loadDistribution": "Default",
          "name": "privateIPLBRule1",
          "probeName": "probe1",
          "protocol": "All"
        }
      ]
    },
    "probes": {
      "value": [
        {
          "intervalInSeconds": 5,
          "name": "probe1",
          "numberOfProbes": 2,
          "port": "62000",
          "protocol": "Tcp"
        }
      ]
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
    "skuName": {
      "value": "Standard"
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

<h3>Example 3: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer './network/load-balancer/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nlbmin'
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressId: '<publicIPAddressId>'
      }
    ]
    name: 'nlbmin001'
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
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "publicIPConfig1",
          "publicIPAddressId": "<publicIPAddressId>"
        }
      ]
    },
    "name": {
      "value": "nlbmin001"
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


## Notes

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

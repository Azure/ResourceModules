# Virtual Network Gateways `[Microsoft.Network/virtualNetworkGateways]`

This module deploys a Virtual Network Gateway.

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
| `Microsoft.Network/publicIPAddresses` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/publicIPAddresses) |
| `Microsoft.Network/virtualNetworkGateways` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/virtualNetworkGateways) |
| `Microsoft.Network/virtualNetworkGateways/natRules` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/virtualNetworkGateways/natRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `gatewayType` | string | `[ExpressRoute, Vpn]` | Specifies the gateway type. E.g. VPN, ExpressRoute. |
| `name` | string |  | Specifies the Virtual Network Gateway name. |
| `skuName` | string | `[Basic, ErGw1AZ, ErGw2AZ, ErGw3AZ, HighPerformance, Standard, UltraPerformance, VpnGw1, VpnGw1AZ, VpnGw2, VpnGw2AZ, VpnGw3, VpnGw3AZ, VpnGw4, VpnGw4AZ, VpnGw5, VpnGw5AZ]` | The SKU of the Gateway. |
| `vNetResourceId` | string |  | Virtual Network resource ID. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `activeActive` | bool | `True` |  | Value to specify if the Gateway should be deployed in active-active or active-passive configuration. |
| `activeGatewayPipName` | string | `[format('{0}-pip2', parameters('name'))]` |  | Specifies the name of the Public IP used by the Virtual Network Gateway when active-active configuration is required. If it's not provided, a '-pip' suffix will be appended to the gateway's name. |
| `allowRemoteVnetTraffic` | bool | `False` |  | Configure this gateway to accept traffic from other Azure Virtual Networks. This configuration does not support connectivity to Azure Virtual WAN. |
| `allowVirtualWanTraffic` | bool | `False` |  | Configures this gateway to accept traffic from remote Virtual WAN networks. |
| `asn` | int | `65815` |  | ASN value. |
| `clientRevokedCertThumbprint` | string | `''` |  | Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet. |
| `clientRootCertData` | string | `''` |  | Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disableIPSecReplayProtection` | bool | `False` |  | disableIPSecReplayProtection flag. Used for VPN Gateways. |
| `domainNameLabel` | array | `[]` |  | DNS name(s) of the Public IP resource(s). If you enabled active-active configuration, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com. |
| `enableBgp` | bool | `True` |  | Value to specify if BGP is enabled or not. |
| `enableBgpRouteTranslationForNat` | bool | `False` |  | EnableBgpRouteTranslationForNat flag. Can only be used when "natRules" are enabled on the Virtual Network Gateway. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableDnsForwarding` | bool | `False` |  | Whether DNS forwarding is enabled or not and is only supported for Express Route Gateways. The DNS forwarding feature flag must be enabled on the current subscription. |
| `enablePrivateIpAddress` | bool | `False` |  | Whether private IP needs to be enabled on this gateway for connections or not. Used for configuring a Site-to-Site VPN connection over ExpressRoute private peering. |
| `gatewayDefaultSiteLocalNetworkGatewayId` | string | `''` |  | The reference to the LocalNetworkGateway resource which represents local network site having default routes. Assign Null value in case of removing existing default site setting. |
| `gatewayPipName` | string | `[format('{0}-pip1', parameters('name'))]` |  | Specifies the name of the Public IP used by the Virtual Network Gateway. If it's not provided, a '-pip' suffix will be appended to the gateway's name. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `natRules` | _[natRules](nat-rules/README.md)_ array | `[]` |  | NatRules for virtual network gateway. NAT is supported on the the following SKUs: VpnGw2~5, VpnGw2AZ~5AZ and is supported for IPsec/IKE cross-premises connections only. |
| `publicIpdiagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, DDoSMitigationFlowLogs, DDoSMitigationReports, DDoSProtectionNotifications]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `publicIpDiagnosticSettingsName` | string | `''` |  | The name of the public IP diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `publicIPPrefixResourceId` | string | `''` |  | Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| `publicIpZones` | array | `[]` |  | Specifies the zones of the Public IP address. Basic IP SKU does not support Availability Zones. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `virtualNetworkGatewaydiagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, GatewayDiagnosticLog, IKEDiagnosticLog, P2SDiagnosticLog, RouteDiagnosticLog, TunnelDiagnosticLog]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `vpnClientAadConfiguration` | object | `{object}` |  | Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided. |
| `vpnClientAddressPoolPrefix` | string | `''` |  | The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network. |
| `vpnGatewayGeneration` | string | `'None'` | `[Generation1, Generation2, None]` | The generation for this VirtualNetworkGateway. Must be None if virtualNetworkGatewayType is not VPN. |
| `vpnType` | string | `'RouteBased'` | `[PolicyBased, RouteBased]` | Specifies the VPN type. |


### Parameter Usage: `subnets`

The `subnets` parameter accepts a JSON Array of `subnet` objects to deploy to the Virtual Network.

Here's an example of specifying a couple Subnets to deploy:

<details>

<summary>Parameter JSON format</summary>

```json
"subnets": {
    "value": [
    {
        "name": "app",
        "properties": {
            "addressPrefix": "10.1.0.0/24",
            "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', 'app-nsg')]"
            },
            "routeTable": {
                "id": "[resourceId('Microsoft.Network/routeTables', 'app-udr')]"
            }
        }
    },
    {
        "name": "data",
        "properties": {
            "addressPrefix": "10.1.1.0/24"
        }
    }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
subnets: [
    {
        name: 'app'
        properties: {
            addressPrefix: '10.1.0.0/24'
            networkSecurityGroup: {
                id: '[resourceId('Microsoft.Network/networkSecurityGroups' 'app-nsg')]'
            }
            routeTable: {
                id: '[resourceId('Microsoft.Network/routeTables' 'app-udr')]'
            }
        }
    }
    {
        name: 'data'
        properties: {
            addressPrefix: '10.1.1.0/24'
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
| `activeActive` | bool | Shows if the virtual network gateway is configured in active-active mode. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual network gateway. |
| `resourceGroupName` | string | The resource group the virtual network gateway was deployed. |
| `resourceId` | string | The resource ID of the virtual network gateway. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/public-ip-addresses` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Aadvpn</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateways './network/virtual-network-gateways/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvngavpn'
  params: {
    // Required parameters
    gatewayType: 'Vpn'
    name: '<<namePrefix>>nvngavpn001'
    skuName: 'VpnGw2AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    activeActive: false
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    domainNameLabel: [
      '<<namePrefix>>-dm-nvngavpn'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    publicIpZones: [
      '1'
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
      Role: 'DeploymentValidation'
    }
    vpnClientAadConfiguration: {
      aadAudience: '41b23e61-6c1e-4545-b367-cd054e0ed4b4'
      aadIssuer: '<aadIssuer>'
      aadTenant: '<aadTenant>'
      vpnAuthenticationTypes: [
        'AAD'
      ]
      vpnClientProtocols: [
        'OpenVPN'
      ]
    }
    vpnType: 'RouteBased'
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
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "<<namePrefix>>nvngavpn001"
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "activeActive": {
      "value": false
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
    "domainNameLabel": {
      "value": [
        "<<namePrefix>>-dm-nvngavpn"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "publicIpZones": {
      "value": [
        "1"
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
        "Role": "DeploymentValidation"
      }
    },
    "vpnClientAadConfiguration": {
      "value": {
        "aadAudience": "41b23e61-6c1e-4545-b367-cd054e0ed4b4",
        "aadIssuer": "<aadIssuer>",
        "aadTenant": "<aadTenant>",
        "vpnAuthenticationTypes": [
          "AAD"
        ],
        "vpnClientProtocols": [
          "OpenVPN"
        ]
      }
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Expressroute</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateways './network/virtual-network-gateways/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvger'
  params: {
    // Required parameters
    gatewayType: 'ExpressRoute'
    name: '<<namePrefix>>nvger001'
    skuName: 'ErGw1AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    domainNameLabel: [
      '<<namePrefix>>-dm-nvger'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    gatewayPipName: '<<namePrefix>>-pip-nvger'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Contact: 'test.user@testcompany.com'
      CostCenter: ''
      Environment: 'Validation'
      PurchaseOrder: ''
      Role: 'DeploymentValidation'
      ServiceName: 'DeploymentValidation'
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
    "gatewayType": {
      "value": "ExpressRoute"
    },
    "name": {
      "value": "<<namePrefix>>nvger001"
    },
    "skuName": {
      "value": "ErGw1AZ"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "domainNameLabel": {
      "value": [
        "<<namePrefix>>-dm-nvger"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "gatewayPipName": {
      "value": "<<namePrefix>>-pip-nvger"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Contact": "test.user@testcompany.com",
        "CostCenter": "",
        "Environment": "Validation",
        "PurchaseOrder": "",
        "Role": "DeploymentValidation",
        "ServiceName": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Vpn</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateways './network/virtual-network-gateways/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvgvpn'
  params: {
    // Required parameters
    gatewayType: 'Vpn'
    name: '<<namePrefix>>nvgvpn001'
    skuName: 'VpnGw2AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    activeActive: true
    allowRemoteVnetTraffic: true
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    disableIPSecReplayProtection: true
    domainNameLabel: [
      '<<namePrefix>>-dm-nvgvpn'
    ]
    enableBgpRouteTranslationForNat: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
    lock: 'CanNotDelete'
    natRules: [
      {
        externalMappings: [
          {
            addressSpace: '192.168.0.0/24'
            portRange: '100'
          }
        ]
        internalMappings: [
          {
            addressSpace: '10.100.0.0/24'
            portRange: '100'
          }
        ]
        mode: 'IngressSnat'
        name: 'nat-rule-1-static-IngressSnat'
        type: 'Static'
      }
      {
        externalMappings: [
          {
            addressSpace: '10.200.0.0/26'
          }
        ]
        internalMappings: [
          {
            addressSpace: '172.16.0.0/26'
          }
        ]
        mode: 'EgressSnat'
        name: 'nat-rule-2-dynamic-EgressSnat'
        type: 'Dynamic'
      }
    ]
    publicIpZones: [
      '1'
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "<<namePrefix>>nvgvpn001"
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "activeActive": {
      "value": true
    },
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "<<namePrefix>>-dm-nvgvpn"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "natRules": {
      "value": [
        {
          "externalMappings": [
            {
              "addressSpace": "192.168.0.0/24",
              "portRange": "100"
            }
          ],
          "internalMappings": [
            {
              "addressSpace": "10.100.0.0/24",
              "portRange": "100"
            }
          ],
          "mode": "IngressSnat",
          "name": "nat-rule-1-static-IngressSnat",
          "type": "Static"
        },
        {
          "externalMappings": [
            {
              "addressSpace": "10.200.0.0/26"
            }
          ],
          "internalMappings": [
            {
              "addressSpace": "172.16.0.0/26"
            }
          ],
          "mode": "EgressSnat",
          "name": "nat-rule-2-dynamic-EgressSnat",
          "type": "Dynamic"
        }
      ]
    },
    "publicIpZones": {
      "value": [
        "1"
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

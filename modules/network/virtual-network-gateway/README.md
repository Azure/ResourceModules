# Virtual Network Gateways `[Microsoft.Network/virtualNetworkGateways]`

This module deploys a Virtual Network Gateway.

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
| `Microsoft.Network/publicIPAddresses` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/publicIPAddresses) |
| `Microsoft.Network/virtualNetworkGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworkGateways) |
| `Microsoft.Network/virtualNetworkGateways/natRules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworkGateways/natRules) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.virtual-network-gateway:1.0.0`.

- [Aadvpn](#example-1-aadvpn)
- [Expressroute](#example-2-expressroute)
- [Vpn](#example-3-vpn)

### Example 1: _Aadvpn_

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br:bicep/modules/network.virtual-network-gateway:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nvngavpn'
  params: {
    // Required parameters
    gatewayType: 'Vpn'
    name: 'nvngavpn001'
    skuName: 'VpnGw2AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    activeActive: false
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    domainNameLabel: [
      'dm-nvngavpn'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    publicIpZones: [
      '1'
      '2'
      '3'
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
      "value": "nvngavpn001"
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
        "dm-nvngavpn"
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
        "1",
        "2",
        "3"
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

### Example 2: _Expressroute_

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br:bicep/modules/network.virtual-network-gateway:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nvger'
  params: {
    // Required parameters
    gatewayType: 'ExpressRoute'
    name: 'nvger001'
    skuName: 'ErGw1AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    domainNameLabel: [
      'dm-nvger'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    gatewayPipName: 'pip-nvger'
    publicIpZones: [
      '1'
      '2'
      '3'
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
      Contact: 'test.user@testcompany.com'
      CostCenter: ''
      Environment: 'Validation'
      'hidden-title': 'This is visible in the resource name'
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
      "value": "nvger001"
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
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "domainNameLabel": {
      "value": [
        "dm-nvger"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "gatewayPipName": {
      "value": "pip-nvger"
    },
    "publicIpZones": {
      "value": [
        "1",
        "2",
        "3"
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
        "Contact": "test.user@testcompany.com",
        "CostCenter": "",
        "Environment": "Validation",
        "hidden-title": "This is visible in the resource name",
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

### Example 3: _Vpn_

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br:bicep/modules/network.virtual-network-gateway:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nvgvpn'
  params: {
    // Required parameters
    gatewayType: 'Vpn'
    name: 'nvgvpn001'
    skuName: 'VpnGw2AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    activeActive: true
    allowRemoteVnetTraffic: true
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgvpn'
    ]
    enableBgpRouteTranslationForNat: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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
      '2'
      '3'
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
      'hidden-title': 'This is visible in the resource name'
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
      "value": "nvgvpn001"
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
        "dm-nvgvpn"
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
        "1",
        "2",
        "3"
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
        "hidden-title": "This is visible in the resource name",
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gatewayType`](#parameter-gatewaytype) | string | Specifies the gateway type. E.g. VPN, ExpressRoute. |
| [`name`](#parameter-name) | string | Specifies the Virtual Network Gateway name. |
| [`skuName`](#parameter-skuname) | string | The SKU of the Gateway. |
| [`vNetResourceId`](#parameter-vnetresourceid) | string | Virtual Network resource ID. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`activeActive`](#parameter-activeactive) | bool | Value to specify if the Gateway should be deployed in active-active or active-passive configuration. |
| [`activeGatewayPipName`](#parameter-activegatewaypipname) | string | Specifies the name of the Public IP used by the Virtual Network Gateway when active-active configuration is required. If it's not provided, a '-pip' suffix will be appended to the gateway's name. |
| [`allowRemoteVnetTraffic`](#parameter-allowremotevnettraffic) | bool | Configure this gateway to accept traffic from other Azure Virtual Networks. This configuration does not support connectivity to Azure Virtual WAN. |
| [`allowVirtualWanTraffic`](#parameter-allowvirtualwantraffic) | bool | Configures this gateway to accept traffic from remote Virtual WAN networks. |
| [`asn`](#parameter-asn) | int | ASN value. |
| [`clientRevokedCertThumbprint`](#parameter-clientrevokedcertthumbprint) | string | Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet. |
| [`clientRootCertData`](#parameter-clientrootcertdata) | string | Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`disableIPSecReplayProtection`](#parameter-disableipsecreplayprotection) | bool | disableIPSecReplayProtection flag. Used for VPN Gateways. |
| [`domainNameLabel`](#parameter-domainnamelabel) | array | DNS name(s) of the Public IP resource(s). If you enabled active-active configuration, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com. |
| [`enableBgp`](#parameter-enablebgp) | bool | Value to specify if BGP is enabled or not. |
| [`enableBgpRouteTranslationForNat`](#parameter-enablebgproutetranslationfornat) | bool | EnableBgpRouteTranslationForNat flag. Can only be used when "natRules" are enabled on the Virtual Network Gateway. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enableDnsForwarding`](#parameter-enablednsforwarding) | bool | Whether DNS forwarding is enabled or not and is only supported for Express Route Gateways. The DNS forwarding feature flag must be enabled on the current subscription. |
| [`enablePrivateIpAddress`](#parameter-enableprivateipaddress) | bool | Whether private IP needs to be enabled on this gateway for connections or not. Used for configuring a Site-to-Site VPN connection over ExpressRoute private peering. |
| [`gatewayDefaultSiteLocalNetworkGatewayId`](#parameter-gatewaydefaultsitelocalnetworkgatewayid) | string | The reference to the LocalNetworkGateway resource which represents local network site having default routes. Assign Null value in case of removing existing default site setting. |
| [`gatewayPipName`](#parameter-gatewaypipname) | string | Specifies the name of the Public IP used by the Virtual Network Gateway. If it's not provided, a '-pip' suffix will be appended to the gateway's name. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`natRules`](#parameter-natrules) | array | NatRules for virtual network gateway. NAT is supported on the the following SKUs: VpnGw2~5, VpnGw2AZ~5AZ and is supported for IPsec/IKE cross-premises connections only. |
| [`publicIpdiagnosticLogCategoriesToEnable`](#parameter-publicipdiagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`publicIpDiagnosticSettingsName`](#parameter-publicipdiagnosticsettingsname) | string | The name of the public IP diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`publicIPPrefixResourceId`](#parameter-publicipprefixresourceid) | string | Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| [`publicIpZones`](#parameter-publicipzones) | array | Specifies the zones of the Public IP address. Basic IP SKU does not support Availability Zones. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualNetworkGatewaydiagnosticLogCategoriesToEnable`](#parameter-virtualnetworkgatewaydiagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`vpnClientAadConfiguration`](#parameter-vpnclientaadconfiguration) | object | Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided. |
| [`vpnClientAddressPoolPrefix`](#parameter-vpnclientaddresspoolprefix) | string | The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network. |
| [`vpnGatewayGeneration`](#parameter-vpngatewaygeneration) | string | The generation for this VirtualNetworkGateway. Must be None if virtualNetworkGatewayType is not VPN. |
| [`vpnType`](#parameter-vpntype) | string | Specifies the VPN type. |

### Parameter: `activeActive`

Value to specify if the Gateway should be deployed in active-active or active-passive configuration.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `activeGatewayPipName`

Specifies the name of the Public IP used by the Virtual Network Gateway when active-active configuration is required. If it's not provided, a '-pip' suffix will be appended to the gateway's name.
- Required: No
- Type: string
- Default: `[format('{0}-pip2', parameters('name'))]`

### Parameter: `allowRemoteVnetTraffic`

Configure this gateway to accept traffic from other Azure Virtual Networks. This configuration does not support connectivity to Azure Virtual WAN.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowVirtualWanTraffic`

Configures this gateway to accept traffic from remote Virtual WAN networks.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `asn`

ASN value.
- Required: No
- Type: int
- Default: `65815`

### Parameter: `clientRevokedCertThumbprint`

Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet.
- Required: No
- Type: string
- Default: `''`

### Parameter: `clientRootCertData`

Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[AllMetrics]`
- Allowed: `[AllMetrics]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `disableIPSecReplayProtection`

disableIPSecReplayProtection flag. Used for VPN Gateways.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `domainNameLabel`

DNS name(s) of the Public IP resource(s). If you enabled active-active configuration, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableBgp`

Value to specify if BGP is enabled or not.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableBgpRouteTranslationForNat`

EnableBgpRouteTranslationForNat flag. Can only be used when "natRules" are enabled on the Virtual Network Gateway.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableDnsForwarding`

Whether DNS forwarding is enabled or not and is only supported for Express Route Gateways. The DNS forwarding feature flag must be enabled on the current subscription.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateIpAddress`

Whether private IP needs to be enabled on this gateway for connections or not. Used for configuring a Site-to-Site VPN connection over ExpressRoute private peering.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `gatewayDefaultSiteLocalNetworkGatewayId`

The reference to the LocalNetworkGateway resource which represents local network site having default routes. Assign Null value in case of removing existing default site setting.
- Required: No
- Type: string
- Default: `''`

### Parameter: `gatewayPipName`

Specifies the name of the Public IP used by the Virtual Network Gateway. If it's not provided, a '-pip' suffix will be appended to the gateway's name.
- Required: No
- Type: string
- Default: `[format('{0}-pip1', parameters('name'))]`

### Parameter: `gatewayType`

Specifies the gateway type. E.g. VPN, ExpressRoute.
- Required: Yes
- Type: string
- Allowed: `[ExpressRoute, Vpn]`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

Specifies the Virtual Network Gateway name.
- Required: Yes
- Type: string

### Parameter: `natRules`

NatRules for virtual network gateway. NAT is supported on the the following SKUs: VpnGw2~5, VpnGw2AZ~5AZ and is supported for IPsec/IKE cross-premises connections only.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicIpdiagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, DDoSMitigationFlowLogs, DDoSMitigationReports, DDoSProtectionNotifications]`

### Parameter: `publicIpDiagnosticSettingsName`

The name of the public IP diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `publicIPPrefixResourceId`

Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.
- Required: No
- Type: string
- Default: `''`

### Parameter: `publicIpZones`

Specifies the zones of the Public IP address. Basic IP SKU does not support Availability Zones.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `skuName`

The SKU of the Gateway.
- Required: Yes
- Type: string
- Allowed: `[Basic, ErGw1AZ, ErGw2AZ, ErGw3AZ, HighPerformance, Standard, UltraPerformance, VpnGw1, VpnGw1AZ, VpnGw2, VpnGw2AZ, VpnGw3, VpnGw3AZ, VpnGw4, VpnGw4AZ, VpnGw5, VpnGw5AZ]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `virtualNetworkGatewaydiagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, GatewayDiagnosticLog, IKEDiagnosticLog, P2SDiagnosticLog, RouteDiagnosticLog, TunnelDiagnosticLog]`

### Parameter: `vNetResourceId`

Virtual Network resource ID.
- Required: Yes
- Type: string

### Parameter: `vpnClientAadConfiguration`

Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `vpnClientAddressPoolPrefix`

The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network.
- Required: No
- Type: string
- Default: `''`

### Parameter: `vpnGatewayGeneration`

The generation for this VirtualNetworkGateway. Must be None if virtualNetworkGatewayType is not VPN.
- Required: No
- Type: string
- Default: `'None'`
- Allowed: `[Generation1, Generation2, None]`

### Parameter: `vpnType`

Specifies the VPN type.
- Required: No
- Type: string
- Default: `'RouteBased'`
- Allowed: `[PolicyBased, RouteBased]`


## Outputs

| Output | Type | Description |
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
| `modules/network/public-ip-address` | Local reference |

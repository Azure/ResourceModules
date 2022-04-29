# Virtual Hubs `[Microsoft.Network/virtualHubs]`

This module deploys a Virtual Hub.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Network/virtualHubs` | 2021-05-01 |
| `Microsoft.Network/virtualHubs/hubRouteTables` | 2021-05-01 |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `addressPrefix` | string | Address-prefix for this VirtualHub. |
| `name` | string | The virtual hub name. |
| `virtualWanId` | string | Resource ID of the virtual WAN to link to |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowBranchToBranchTraffic` | bool | `True` |  | Flag to control transit for VirtualRouter hub. |
| `azureFirewallId` | string | `''` |  | Resource ID of the Azure Firewall to link to |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `expressRouteGatewayId` | string | `''` |  | Resource ID of the Express Route Gateway to link to |
| `hubRouteTables` | _[hubRouteTables](hubRouteTables/readme.md)_ array | `[]` |  | Route tables to create for the virtual hub. |
| `hubVirtualNetworkConnections` | _[hubVirtualNetworkConnections](hubVirtualNetworkConnections/readme.md)_ array | `[]` |  | Virtual network connections to create for the virtual hub. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `p2SVpnGatewayId` | string | `''` |  | Resource ID of the Point-to-Site VPN Gateway to link to |
| `preferredRoutingGateway` | string | `''` | `[ExpressRoute, None, VpnGateway, ]` | The preferred routing gateway types |
| `routeTableRoutes` | array | `[]` |  | VirtualHub route tables |
| `securityPartnerProviderId` | string | `''` |  | ID of the Security Partner Provider to link to |
| `securityProviderName` | string | `''` |  | The Security Provider name. |
| `sku` | string | `'Standard'` | `[Basic, Standard]` | The sku of this VirtualHub. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `virtualHubRouteTableV2s` | array | `[]` |  | List of all virtual hub route table v2s associated with this VirtualHub. |
| `virtualRouterAsn` | int | `-1` |  | VirtualRouter ASN. |
| `virtualRouterIps` | array | `[]` |  | VirtualRouter IPs. |
| `vpnGatewayId` | string | `''` |  | Resource ID of the VPN Gateway to link to |


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
| `name` | string | The name of the virtual hub |
| `resourceGroupName` | string | The resource group the virtual hub was deployed into |
| `resourceId` | string | The resource ID of the virtual hub |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Virtualhubs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualHubs)
- [Virtualhubs/Hubroutetables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualHubs/hubRouteTables)
- [Virtualhubs/Hubvirtualnetworkconnections](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualHubs/hubVirtualNetworkConnections)

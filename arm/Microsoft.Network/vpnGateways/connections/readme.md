# VPN Gateways Connections `[Microsoft.Network/vpnGateways/connections]`

This module deploys VPN Gateways Connections.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/vpnGateways/vpnConnections` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `connectionBandwidth` | int | `10` |  | Optional. Expected bandwidth in MBPS. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `dpdTimeoutSeconds` | int |  |  | Optional. DPD timeout in seconds for VPN connection. |
| `enableBgp` | bool |  |  | Optional. Enable internet security. |
| `enableInternetSecurity` | bool |  |  | Optional. Enable internet security. |
| `enableRateLimiting` | bool |  |  | Optional. EnableBgp flag. |
| `ipsecPolicies` | array | `[]` |  | Optional. The IPSec Policies to be considered by this connection. |
| `name` | string |  |  | Required. The name of the VPN connection. |
| `remoteVpnSiteResourceId` | string |  |  | Optional. Reference to a VPN site to link to |
| `routingConfiguration` | object | `{object}` |  | Optional. Routing Configuration indicating the associated and propagated route tables for this connection. |
| `routingWeight` | int |  |  | Optional. Routing weight for VPN connection. |
| `sharedKey` | string |  |  | Optional. SharedKey for the VPN connection. |
| `trafficSelectorPolicies` | array | `[]` |  | Optional. The Traffic Selector Policies to be considered by this connection. |
| `useLocalAzureIpAddress` | bool |  |  | Optional. Use local azure IP to initiate connection. |
| `usePolicyBasedTrafficSelectors` | bool |  |  | Optional. Enable policy-based traffic selectors. |
| `vpnConnectionProtocolType` | string | `IKEv2` | `[IKEv1, IKEv2]` | Optional. Gateway connection protocol. |
| `vpnGatewayName` | string |  |  | Required. The name of the VPN gateway this VPN connection is associated with. |
| `vpnLinkConnections` | array | `[]` |  | Optional. List of all VPN site link connections to the gateway. |

### Parameter Usage: `routingConfiguration`

```json
"routingConfiguration": {
    "associatedRouteTable": {
        "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualHubs/SampleVirtualHub/hubRouteTables/defaultRouteTable"
    },
    "propagatedRouteTables": {
        "labels": [
            "default"
        ],
        "ids": [
            {
                "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualHubs/SampleVirtualHub/hubRouteTables/defaultRouteTable"
            }
        ]
    },
    "vnetRoutes": {
        "staticRoutes": []
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the VPN connection |
| `resourceGroupName` | string | The name of the resource group the VPN connection was deployed into |
| `resourceId` | string | The resource ID of the VPN connection |

## Template references

- [Vpngateways/Vpnconnections](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/vpnGateways/vpnConnections)

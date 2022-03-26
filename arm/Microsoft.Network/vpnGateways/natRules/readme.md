# VPN Gateways NATRules `[Microsoft.Network/vpnGateways/natRules]`

This module deploys VPN Gateways NATRules

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/vpnGateways/natRules` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `externalMappings` | array | `[]` |  | Optional. An address prefix range of destination IPs on the outside network that source IPs will be mapped to. In other words, your post-NAT address prefix range. |
| `internalMappings` | array | `[]` |  | Optional. An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range. |
| `ipConfigurationId` | string |  |  | Optional. A NAT rule must be configured to a specific VPN Gateway instance. This is applicable to Dynamic NAT only. Static NAT rules are automatically applied to both VPN Gateway instances. |
| `mode` | string |  | `[, EgressSnat, IngressSnat]` | Optional. The type of NAT rule for VPN NAT. IngressSnat mode (also known as Ingress Source NAT) is applicable to traffic entering the Azure hub's site-to-site VPN gateway. EgressSnat mode (also known as Egress Source NAT) is applicable to traffic leaving the Azure hub's Site-to-site VPN gateway. |
| `name` | string |  |  | Required. The name of the NAT rule. |
| `type` | string |  | `[, Dynamic, Static]` | Optional. The type of NAT rule for VPN NAT. Static one-to-one NAT establishes a one-to-one relationship between an internal address and an external address while Dynamic NAT assigns an IP and port based on availability. |
| `vpnGatewayName` | string |  |  | Required. The name of the VPN gateway this NAT rule is associated with. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the NAT rule |
| `resourceGroupName` | string | The name of the resource group the NAT rule was deployed into |
| `resourceId` | string | The resource ID of the NAT rule |

## Template references

- [Vpngateways/Natrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/vpnGateways/natRules)

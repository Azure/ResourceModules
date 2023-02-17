# VPN Gateways NATRules `[Microsoft.Network/virtualNetworkGateways/natRules]`

This module deploys Virtual Network Gateways NATRules

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualNetworkGateways/natRules` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/virtualNetworkGateways/natRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the NAT rule. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `virtualNetworkGatewayName` | string | The name of the parent Virtual Network Gateway this NAT rule is associated with. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `externalMappings` | array | `[]` |  | An address prefix range of destination IPs on the outside network that source IPs will be mapped to. In other words, your post-NAT address prefix range. |
| `internalMappings` | array | `[]` |  | An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range. |
| `ipConfigurationId` | string | `''` |  | A NAT rule must be configured to a specific Virtual Network Gateway instance. This is applicable to Dynamic NAT only. Static NAT rules are automatically applied to both Virtual Network Gateway instances. |
| `mode` | string | `''` | `['', EgressSnat, IngressSnat]` | The type of NAT rule for Virtual Network NAT. IngressSnat mode (also known as Ingress Source NAT) is applicable to traffic entering the Azure hub's site-to-site Virtual Network gateway. EgressSnat mode (also known as Egress Source NAT) is applicable to traffic leaving the Azure hub's Site-to-site Virtual Network gateway. |
| `type` | string | `''` | `['', Dynamic, Static]` | The type of NAT rule for Virtual Network NAT. Static one-to-one NAT establishes a one-to-one relationship between an internal address and an external address while Dynamic NAT assigns an IP and port based on availability. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the NAT rule. |
| `resourceGroupName` | string | The name of the resource group the NAT rule was deployed into. |
| `resourceId` | string | The resource ID of the NAT rule. |

## Cross-referenced modules

_None_

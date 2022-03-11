# Network Security Groups Security Rules `[Microsoft.Network/networkSecurityGroups/securityRules]`

This module deploys Network Security Group Security Rules.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkSecurityGroups/securityRules` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `access` | string | `Deny` | `[Allow, Deny]` | Optional. Whether network traffic is allowed or denied. |
| `description` | string |  |  | Optional. A description for this rule |
| `destinationAddressPrefix` | string |  |  | Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| `destinationAddressPrefixes` | array | `[]` |  | Optional. The destination address prefixes. CIDR or destination IP ranges. |
| `destinationApplicationSecurityGroups` | array | `[]` |  | Optional. The application security group specified as destination. |
| `destinationPortRange` | string |  |  | Optional. The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| `destinationPortRanges` | array | `[]` |  | Optional. The destination port ranges. |
| `direction` | string |  | `[Inbound, Outbound]` | Required. The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string |  |  | Required. The name of the security rule |
| `networkSecurityGroupName` | string |  |  | Required. The name of the network security group to deploy the security rule into |
| `priority` | int |  |  | Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| `protocol` | string |  | `[*, Ah, Esp, Icmp, Tcp, Udp]` | Required. Network protocol this rule applies to. |
| `sourceAddressPrefix` | string |  |  | Optional. The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| `sourceAddressPrefixes` | array | `[]` |  | Optional. The CIDR or source IP ranges. |
| `sourceApplicationSecurityGroups` | array | `[]` |  | Optional. The application security group specified as source. |
| `sourcePortRange` | string |  |  | Optional. The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| `sourcePortRanges` | array | `[]` |  | Optional. The source port ranges. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the security rule |
| `resourceGroupName` | string | The resource group the security rule was deployed into |
| `resourceId` | string | The resource ID of the security rule |

## Template references

- [Networksecuritygroups/Securityrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/networkSecurityGroups/securityRules)

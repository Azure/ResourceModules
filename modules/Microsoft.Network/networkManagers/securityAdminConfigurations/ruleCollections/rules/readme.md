# Network NetworkManagers SecurityAdminConfigurations RuleCollections Rules `[Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules]`

This module deploys Network NetworkManagers SecurityAdminConfigurations RuleCollections Rules.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2022-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `access` | string | `[Allow, AlwaysAllow, Deny]` | Indicates the access allowed for this particular rule. "Allow" means traffic matching this rule will be allowed. "Deny" means traffic matching this rule will be blocked. "AlwaysAllow" means that traffic matching this rule will be allowed regardless of other rules with lower priority or user-defined NSGs. |
| `direction` | string | `[Inbound, Outbound]` | Indicates if the traffic matched against the rule in inbound or outbound. |
| `name` | string |  | The name of the rule. |
| `priority` | int |  | The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| `protocol` | string | `[Ah, Any, Esp, Icmp, Tcp, Udp]` | Network protocol this rule applies to. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `networkManagerName` | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |
| `ruleCollectionName` | string | The name of the parent rule collection. Required if the template is used in a standalone deployment. |
| `securityAdminConfigurationName` | string | The name of the parent security admin configuration. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string | `''` |  | A description of the rule. |
| `destinationPortRanges` | array | `[]` |  | List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535. |
| `destinationsAddressPrefix` | string | `''` |  | Provide the destination address prefix range using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64), or a service tag (e.g. AppService.WestEurope). You can also provide a comma-separated list of IP addresses or address ranges using either IPv4 or IPv6. |
| `destinationsAddressPrefixType` | string | `''` | `['', IPPrefix, ServiceTag]` | The destination filter can be an IP Address or a service tag. It specifies the outgoing traffic for a specific destination IP address range that will be allowed or denied by this rule. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `sourcePortRanges` | array | `[]` |  | List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535. |
| `sourcesAddressPrefix` | string | `''` |  | Provide an address range using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64), or an IP address (e.g. 192.168.99.0 or 2001:1234::), or a service tag (e.g. AppService.WestEurope). You can also provide a comma-separated list of IP addresses or address ranges using either IPv4 or IPv6. |
| `sourcesAddressPrefixType` | string | `''` | `['', IPPrefix, ServiceTag]` | The source filter can be an IP Address or a service tag. It specifies the incoming traffic from a specific source IP addresses range that will be allowed or denied by this rule. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed rule. |
| `resourceGroupName` | string | The resource group the rule was deployed into. |
| `resourceId` | string | The resource ID of the deployed rule. |

## Cross-referenced modules

_None_

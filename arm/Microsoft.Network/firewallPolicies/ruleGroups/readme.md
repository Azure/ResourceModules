# Network Firewall Policies Rule Groups `[Microsoft.Network/firewallPolicies/ruleGroups]`

This module deploys Network FirewallPolicies Rule Groups.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/firewallPolicies/ruleGroups` | 2020-04-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `firewallPolicyName` | string | Name of the Firewall Policy. |
| `name` | string | The name of the rule group to deploy |
| `priority` | int | Priority of the Firewall Policy Rule Group resource. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `rules` | array | `[]` | Group of Firewall rules. |


### Parameter Usage: `rules`

For remaining properties, see [FirewallPolicyRule objects](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2020-04-01/firewallpolicies/rulegroups?tabs=json#firewallpolicyrule-objects)

```json
"rules": [
    {
    "name": "string",
    "priority": "int",
    "ruleType": "string"
    // For remaining properties, see FirewallPolicyRule objects
    }
]
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed rule group |
| `resourceGroupName` | string | The resource group of the deployed rule group |
| `resourceId` | string | The resource ID of the deployed rule group |

## Template references

- ['firewallPolicies/ruleGroups' Parent Documentation](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/firewallPolicies)

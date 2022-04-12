# Network Firewall Policies Rule Collection Groups `[Microsoft.Network/firewallPolicies/ruleCollectionGroups]`

This module deploys Network Firewall Policies Rule Collection Groups.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/firewallPolicies/ruleCollectionGroups` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `firewallPolicyName` | string | Name of the Firewall Policy. |
| `name` | string | The name of the rule collection group to deploy |
| `priority` | int | Priority of the Firewall Policy Rule Collection Group resource. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `ruleCollections` | array | `[]` | Group of Firewall Policy rule collections. |


### Parameter Usage: `ruleCollections`

For remaining properties, see [FirewallPolicyRuleCollection objects](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/firewallpolicies/rulecollectiongroups?tabs=json#firewallpolicyrulecollection-objects)

```json
"ruleCollections": [
    {
    "name": "string",
    "priority": "int",
    "ruleCollectionType": "string"
    // For remaining properties, see FirewallPolicyRuleCollection objects
    }
]
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed rule collection group |
| `resourceGroupName` | string | The resource group of the deployed rule collection group |
| `resourceId` | string | The resource ID of the deployed rule collection group |

## Template references

- [Firewallpolicies/Rulecollectiongroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/firewallPolicies/ruleCollectionGroups)

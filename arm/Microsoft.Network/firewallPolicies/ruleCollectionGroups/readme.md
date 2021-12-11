# Network Firewall Policies Rule Collection Groups `[Microsoft.Network/firewallPolicies/ruleCollectionGroups]`

This module deploys Network Firewall Policies Rule Collection Groups.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/firewallPolicies/ruleCollectionGroups` | 2021-03-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `firewallPolicyName` | string |  |  | Required. Name of the Firewall Policy. |
| `name` | string |  |  | Required. The name of the rule collection group to deploy |
| `priority` | int |  |  | Required. Priority of the Firewall Policy Rule Collection Group resource. |
| `ruleCollections` | array | `[]` |  | Optional. Group of Firewall Policy rule collections. |

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
| `ruleCollectionGroupName` | string | The name of the deployed rule collection group |
| `ruleCollectionGroupResourceGroup` | string | The resource group of the deployed rule collection group |
| `ruleCollectionGroupResourceId` | string | The resource ID of the deployed rule collection group |

## Template references

- [Firewallpolicies/Rulecollectiongroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/firewallPolicies/ruleCollectionGroups)

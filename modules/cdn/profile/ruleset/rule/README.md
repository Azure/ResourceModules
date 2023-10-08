# CDN Profiles Rules `[Microsoft.Cdn/profiles/ruleSets/rules]`

This module deploys a CDN Profile rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/ruleSets/rules` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/profiles/ruleSets/rules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `matchProcessingBehavior` | string | `[Continue, Stop]` | If this rule is a match should the rules engine continue running the remaining rules or stop. If not present, defaults to Continue. |
| `name` | string |  | The name of the rule. |
| `order` | int |  | The order in which this rule will be applied. Rules with a lower order are applied before rules with a higher order. |
| `profileName` | string |  | The name of the profile. |
| `ruleSetName` | string |  | The name of the rule set. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `actions` | array | `[]` | A list of actions that are executed when all the conditions of a rule are satisfied. |
| `conditions` | array | `[]` | A list of conditions that must be matched for the actions to be executed. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the rule. |
| `resourceGroupName` | string | The name of the resource group the custom domain was created in. |
| `resourceId` | string | The resource id of the rule. |

## Cross-referenced modules

_None_

# EventHub Namespace Authorization Rule `[Microsoft.EventHub/namespaces/authorizationRules]`

This module deploys an EventHub Namespace Authorization Rule

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.EventHub/namespaces/authorizationRules` | 2017-04-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. The name of the authorization rule |
| `namespaceName` | string |  |  | Required. The name of the EventHub namespace |
| `rights` | array | `[]` | `[Listen, Manage, Send]` | Optional. The rights associated with the rule. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `authorizationRuleName` | string | The name of the authorization rule. |
| `authorizationRuleResourceGroup` | string | The name of the Resource Group the authorization rule was created in. |
| `authorizationRuleResourceId` | string | The Resource Id of the authorization rule. |

## Template references

- [Namespaces/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2017-04-01/namespaces/authorizationRules)

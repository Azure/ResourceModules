# EventHub Namespace Authorization Rule `[Microsoft.EventHub/namespaces/authorizationRules]`

This module deploys an EventHub Namespace Authorization Rule

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventHub/namespaces/authorizationRules` | 2017-04-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization rule |
| `namespaceName` | string | The name of the event hub namespace |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `rights` | array | `[]` | `[Listen, Manage, Send]` | The rights associated with the rule. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization rule. |
| `resourceGroupName` | string | The name of the resource group the authorization rule was created in. |
| `resourceId` | string | The resource ID of the authorization rule. |

## Template references

- [Namespaces/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2017-04-01/namespaces/authorizationRules)

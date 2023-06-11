# Service Bus Namespace Topic Authorization Rules `[Microsoft.ServiceBus/namespaces/topics/authorizationRules]`

This module deploys a Service Bus Namespace Topic Authorization Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/topics/authorizationRules` | [2021-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces/topics/authorizationRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the service bus namespace topic. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `namespaceName` | string | The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment. |
| `topicName` | string | The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `rights` | array | `[]` | `[Listen, Manage, Send]` | The rights associated with the rule. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization rule. |
| `resourceGroupName` | string | The name of the Resource Group the authorization rule was created in. |
| `resourceId` | string | The Resource ID of the authorization rule. |

## Cross-referenced modules

_None_

# ServiceBus Namespace Topic Authorization Rules `[Microsoft.ServiceBus/namespaces/topics/authorizationRules]`

This module deploys an authorization rule for a service bus namespace topic.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/topics/authorizationRules` | 2021-06-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the service bus namespace topic |
| `namespaceName` | string | The name of the parent service bus namespace |
| `topicName` | string | The name of the parent service bus namespace topic |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `rights` | array | `[]` | `[Listen, Manage, Send]` | The rights associated with the rule. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization rule. |
| `resourceGroupName` | string | The name of the Resource Group the authorization rule was created in. |
| `resourceId` | string | The Resource ID of the authorization rule. |

## Template references

- [Namespaces/Topics/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces/topics/authorizationRules)

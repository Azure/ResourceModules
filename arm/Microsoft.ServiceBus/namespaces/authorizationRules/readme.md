# ServiceBus Namespace Authorization Rules `[Microsoft.ServiceBus/namespaces/authorizationRules]`

This module deploys authorization rules for a service bus namespace

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/AuthorizationRules` | 2017-04-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization rule |
| `namespaceName` | string | Name of the parent Service Bus Namespace for the Service Bus Queue. |

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
| `resourceId` | string | The resource ID of the authorization rule. |

## Template references

- [Namespaces/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/AuthorizationRules)

# EventHub Namespace EventHubs Authorization Rule `[Microsoft.EventHub/namespaces/eventhubs/authorizationRules]`

This module deploys an EventHub Namespace EventHubs Authorization Rule

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventHub/namespaces/eventhubs/authorizationRules` | [2021-11-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-11-01/namespaces/eventhubs/authorizationRules) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization rule. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `eventHubName` | string | The name of the parent event hub namespace event hub. Required if the template is used in a standalone deployment. |
| `namespaceName` | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment. |

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

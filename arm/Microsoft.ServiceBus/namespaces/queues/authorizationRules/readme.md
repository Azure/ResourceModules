# ServiceBus Namespace Queue Authorization Rules `[Microsoft.ServiceBus/namespaces/queues/authorizationRules]`

This module deploys an authorization rule for a service bus namespace queue.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/queues/authorizationRules` | 2017-04-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. The name of the service bus namepace queue |
| `namespaceName` | string |  |  | Required. The name of the parent service bus namespace |
| `queueName` | string |  |  | Required. The name of the parent service bus namespace queue |
| `rights` | array | `[]` | `[Listen, Manage, Send]` | Optional. The rights associated with the rule. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization rule. |
| `resourceGroupName` | string | The name of the Resource Group the authorization rule was created in. |
| `resourceId` | string | The Resource ID of the authorization rule. |

## Template references

- [Namespaces/Queues/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/queues/authorizationRules)

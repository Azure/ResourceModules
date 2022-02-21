# ServiceBus Namespace Topic Authorization Rules `[Microsoft.ServiceBus/namespaces/topics/authorizationRules]`

This module deploys an authorization rule for a service bus namespace topic.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/topics/authorizationRules` | 2021-06-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. The name of the service bus namespace topic |
| `namespaceName` | string |  |  | Required. The name of the parent service bus namespace |
| `rights` | array | `[]` | `[Listen, Manage, Send]` | Optional. The rights associated with the rule. |
| `topicName` | string |  |  | Required. The name of the parent service bus namespace topic |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization rule. |
| `resourceGroupName` | string | The name of the Resource Group the authorization rule was created in. |
| `resourceId` | string | The Resource ID of the authorization rule. |

## Template references

- [Namespaces/Topics/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces/topics/authorizationRules)

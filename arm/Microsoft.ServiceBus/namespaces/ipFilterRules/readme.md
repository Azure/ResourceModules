# ServiceBus Namespace Ip-Filter Rules `[Microsoft.ServiceBus/namespaces/ipFilterRules]`

This module deploys IP filter rules for a service bus namespace

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/ipfilterrules` | 2018-01-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `action` | string |  | `[Accept]` | Required. The IP Filter Action |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `filterName` | string |  |  | Required. IP Filter name |
| `ipMask` | string |  |  | Required. IP Mask |
| `name` | string | `[parameters('filterName')]` |  | Optional. The name of the ip filter rule |
| `namespaceName` | string |  |  | Required. Name of the parent Service Bus Namespace for the Service Bus Queue. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the IP filter rule. |
| `resourceGroupName` | string | The name of the Resource Group the IP filter rule was created in. |
| `resourceId` | string | The Resource ID of the IP filter rule. |

## Template references

- [Namespaces/Ipfilterrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces/ipfilterrules)

# ServiceBus Namespace Ip-Filter Rules `[Microsoft.ServiceBus/namespaces/ipFilterRules]`

This module deploys IP filter rules for a service bus namespace

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/ipfilterrules` | [2018-01-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces/ipfilterrules) |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `action` | string | `[Accept]` | The IP Filter Action. |
| `filterName` | string |  | IP Filter name. |
| `ipMask` | string |  | IP Mask. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `namespaceName` | string | The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `[parameters('filterName')]` | The name of the ip filter rule. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the IP filter rule. |
| `resourceGroupName` | string | The name of the Resource Group the IP filter rule was created in. |
| `resourceId` | string | The Resource ID of the IP filter rule. |

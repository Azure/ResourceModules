# ServiceBus Namespace Virtual Network Rules `[Microsoft.ServiceBus/namespaces/virtualNetworkRules]`

This module deploys a virtual network rule for a service bus namespace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/virtualnetworkrules` | [2018-01-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces/virtualnetworkrules) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `virtualNetworkSubnetId` | string | Resource ID of Virtual Network Subnet. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `namespaceName` | string | The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `[format('{0}-vnr', parameters('namespaceName'))]` | The name of the virtual network rule. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual network rule. |
| `resourceGroupName` | string | The name of the Resource Group the virtual network rule was created in. |
| `resourceId` | string | The Resource ID of the virtual network rule. |

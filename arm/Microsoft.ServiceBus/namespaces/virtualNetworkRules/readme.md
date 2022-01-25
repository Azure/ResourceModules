# ServiceBus Namespace Virtual Network Rules `[Microsoft.ServiceBus/namespaces/virtualNetworkRules]`

This module deploys a virtual network rule for a service bus namespace.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/virtualnetworkrules` | 2018-01-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string | `[format('{0}-vnr', parameters('namespaceName'))]` |  | Optional. The name of the virtual network rule |
| `namespaceName` | string |  |  | Required. Name of the parent Service Bus Namespace for the Service Bus Queue. |
| `virtualNetworkSubnetId` | string |  |  | Required. Resource ID of Virtual Network Subnet |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual network rule. |
| `resourceGroupName` | string | The name of the Resource Group the virtual network rule was created in. |
| `resourceId` | string | The Resource ID of the virtual network rule. |

## Template references

- [Namespaces/Virtualnetworkrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces/virtualnetworkrules)

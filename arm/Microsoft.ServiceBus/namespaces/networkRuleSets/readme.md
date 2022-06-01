# ServiceBus Namespaces NetworkRuleSets `[Microsoft.ServiceBus/namespaces/networkRuleSets]`

This module deploys ServiceBus Namespaces NetworkRuleSets.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/networkRuleSets` | [2021-11-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-11-01/namespaces/networkRuleSets) |

## Parameters

**Required parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `name` | string | `'default'` | The default is the only valid ruleset. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `namespaceName` | string | The name of the parent Service Bus Namespace for the Service Bus Network Rule Set. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowTrustedServices` | bool | `True` |  | Trusted Services Bypass for Premium Sku. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `publicNetworkAccess` | string | `'Disabled'` | `[Enabled, Disabled]` | Public Network Access for Premium Sku. |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Network ACL Deployment. |
| `resourceGroupName` | string | The name of the Resource Group the virtual network rule was created in. |
| `resourceId` | string | The Resource ID of the virtual network rule. |

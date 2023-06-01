# Web/Function Apps Hybrid Connection Relay `[Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays]`

This module deploys Web Sites Hybrid Connecton Relays.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/sites/slots/hybridConnectionNamespaces/relays) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `resourceId` | string | The resource id of the resource. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `slotName` | string | The name of the parent web site slot. Required if the template is used in a standalone deployment |
| `webAppName` | string | The name of the parent web site. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all Resources. |
| `sendKeyName` | string | `'defaultSender'` | Name of the authorization rule send key to use. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The name of the resource group the resource was deployed into. |

## Cross-referenced modules

_None_

# Web/Function Apps Hybrid Connection Relay  `[Microsoft.Web/sites/hybridConnectionNamespaces/relays]`

This module deploys Web Sites Hybrid Connecton Relays.

## Navigation

- [Web/Function Apps Hybrid Connection Relay  `[Microsoft.Web/sites/hybridConnectionNamespaces/relays]`](#webfunction-apps-hybrid-connection-relay--microsoftwebsiteshybridconnectionnamespacesrelays)
  - [Navigation](#navigation)
  - [Resource Types](#resource-types)
  - [Parameters](#parameters)
  - [Outputs](#outputs)
  - [Cross-referenced modules](#cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/hybridConnectionNamespaces/relays` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/sites/hybridConnectionNamespaces/relays) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `resourceId` | string | The resource id of the resource. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
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

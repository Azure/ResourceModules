# DBforMySQL Flexible Server Administrators `[Microsoft.DBforMySQL/flexibleServers/administrators]`

This module deploys a DBforMySQL Flexible Server Administrator.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforMySQL/flexibleServers/administrators` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2022-01-01/flexibleServers/administrators) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `identityResourceId` | string | The resource ID of the identity used for AAD Authentication. |
| `login` | string | Login name of the server administrator. |
| `sid` | string | SID (object ID) of the server administrator. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `flexibleServerName` | string | The name of the parent DBforMySQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `tenantId` | string | `[tenant().tenantId]` | The tenantId of the Active Directory administrator. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed administrator. |
| `resourceGroupName` | string | The resource group of the deployed administrator. |
| `resourceId` | string | The resource ID of the deployed administrator. |

## Cross-referenced modules

_None_

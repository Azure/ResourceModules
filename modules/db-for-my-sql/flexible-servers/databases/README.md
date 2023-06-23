# DBforMySQL Flexible Server Databases `[Microsoft.DBforMySQL/flexibleServers/databases]`

This module deploys a DBforMySQL Flexible Server Database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforMySQL/flexibleServers/databases` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/flexibleServers/databases) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the database. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `flexibleServerName` | string | The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `charset` | string | `'utf8_general_ci'` | The charset of the database. |
| `collation` | string | `'utf8'` | The collation of the database. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed database. |
| `resourceGroupName` | string | The resource group of the deployed database. |
| `resourceId` | string | The resource ID of the deployed database. |

## Cross-referenced modules

_None_

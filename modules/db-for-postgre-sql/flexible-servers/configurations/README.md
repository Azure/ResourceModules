# DBforPostgreSQL Flexible Server Configurations `[Microsoft.DBforPostgreSQL/flexibleServers/configurations]`

This module deploys a DBforPostgreSQL Flexible Server Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforPostgreSQL/flexibleServers/configurations` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/configurations) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the configuration. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `flexibleServerName` | string | The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `source` | string | `''` | Source of the configuration. |
| `value` | string | `''` | Value of the configuration. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed configuration. |
| `resourceGroupName` | string | The resource group of the deployed configuration. |
| `resourceId` | string | The resource ID of the deployed configuration. |

## Cross-referenced modules

_None_

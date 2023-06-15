# SQL Server Database Long Term Backup Retention Policies `[Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies]`

This module deploys an Azure SQL Server Database Long-Term Backup Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupLongTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `databaseName` | string | The name of the parent database. |
| `serverName` | string | The name of the parent SQL Server. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `monthlyRetention` | string | `''` | Weekly retention in ISO 8601 duration format. |
| `weeklyRetention` | string | `''` | Monthly retention in ISO 8601 duration format. |
| `weekOfYear` | int | `1` | Week of year backup to keep for yearly retention. |
| `yearlyRetention` | string | `''` | Yearly retention in ISO 8601 duration format. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the long-term policy. |
| `resourceGroupName` | string | The resource group the long-term policy was deployed into. |
| `resourceId` | string | The resource ID of the long-term policy. |

## Cross-referenced modules

_None_

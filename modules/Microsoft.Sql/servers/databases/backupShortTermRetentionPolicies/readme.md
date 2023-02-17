# SQL Server Database Short Term Backup Retention Policy `[Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies]`

This module deploys a short term retention policy for a Azure SQL Database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupShortTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `databaseName` | string | The name of the parent database. |
| `serverName` | string | The name of the parent SQL Server. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `diffBackupIntervalInHours` | int | `24` | Differential backup interval in hours. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `retentionDays` | int | `7` | Poin-in-time retention in days. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the short-term policy. |
| `resourceGroupName` | string | The resource group the short-term policy was deployed into. |
| `resourceId` | string | The resource ID of the short-term policy. |

## Cross-referenced modules

_None_

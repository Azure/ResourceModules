# SQL Managed Instance Database Backup Short-Term Retention Policy `[Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies]`

This module deploys a backup short-term retention policies for SQL Managed Instance databases


## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | [2017-03-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-03-01-preview/managedInstances/databases/backupShortTermRetentionPolicies) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Short Term Retention backup policy. For example "default". |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `databaseName` | string | The name of the parent SQL managed instance database. Required if the template is used in a standalone deployment. |
| `managedInstanceName` | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `retentionDays` | int | `35` | The backup retention period in days. This is how many days Point-in-Time Restore will be supported. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed database backup short-term retention policy. |
| `resourceGroupName` | string | The resource group of the deployed database backup short-term retention policy. |
| `resourceId` | string | The resource ID of the deployed database backup short-term retention policy. |

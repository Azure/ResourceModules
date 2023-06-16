# SQL Managed Instance Database Backup Long-Term Retention Policies `[Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies]`

This module deploys a SQL Managed Instance Database Backup Long-Term Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/managedInstances/databases/backupLongTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Long Term Retention backup policy. For example "default". |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `databaseName` | string | The name of the parent managed instance database. Required if the template is used in a standalone deployment. |
| `managedInstanceName` | string | The name of the parent managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `monthlyRetention` | string | `'P1Y'` | The monthly retention policy for an LTR backup in an ISO 8601 format. |
| `weeklyRetention` | string | `'P1M'` | The weekly retention policy for an LTR backup in an ISO 8601 format. |
| `weekOfYear` | int | `5` | The week of year to take the yearly backup in an ISO 8601 format. |
| `yearlyRetention` | string | `'P5Y'` | The yearly retention policy for an LTR backup in an ISO 8601 format. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed database backup long-term retention policy. |
| `resourceGroupName` | string | The resource group of the deployed database backup long-term retention policy. |
| `resourceId` | string | The resource ID of the deployed database backup long-term retention policy. |

## Cross-referenced modules

_None_

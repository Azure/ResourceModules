# SQL Managed Instance Database Backup Short-Term Retention Policies `[Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies]`

This module deploys a SQL Managed Instance Database Backup Short-Term Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/databases/backupShortTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Short Term Retention backup policy. For example "default". |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseName`](#parameter-databasename) | string | The name of the parent SQL managed instance database. Required if the template is used in a standalone deployment. |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`retentionDays`](#parameter-retentiondays) | int | The backup retention period in days. This is how many days Point-in-Time Restore will be supported. |

### Parameter: `databaseName`

The name of the parent SQL managed instance database. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `managedInstanceName`

The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `name`

The name of the Short Term Retention backup policy. For example "default".
- Required: Yes
- Type: string

### Parameter: `retentionDays`

The backup retention period in days. This is how many days Point-in-Time Restore will be supported.
- Required: No
- Type: int
- Default: `35`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed database backup short-term retention policy. |
| `resourceGroupName` | string | The resource group of the deployed database backup short-term retention policy. |
| `resourceId` | string | The resource ID of the deployed database backup short-term retention policy. |

## Cross-referenced modules

_None_

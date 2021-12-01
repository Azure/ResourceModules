# SQL Managed Instance Database Backup Short-Term Retention Policy `[Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies]`

This module deploys a backup short-term retention policies for SQL Managed Instance databases


## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | 2017-03-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `databaseName` | string |  |  | Required. The name of the SQL managed instance database |
| `managedInstanceName` | string |  |  | Required. Name of the SQL managed instance. |
| `name` | string |  |  | Required. The name of the Short Term Retention backup policy. For example "default". |
| `retentionDays` | int | `35` |  | Optional. The backup retention period in days. This is how many days Point-in-Time Restore will be supported. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `backupShortTermRetentionPolicyName` | string | The name of the deployed database backup short-term retention policy |
| `backupShortTermRetentionPolicyResourceGroup` | string | The resource group of the deployed database backup short-term retention policy |
| `backupShortTermRetentionPolicyResourceId` | string | The resource ID of the deployed database backup short-term retention policy |

## Template references

- [Managedinstances/Databases/Backupshorttermretentionpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-03-01-preview/managedInstances/databases/backupShortTermRetentionPolicies)

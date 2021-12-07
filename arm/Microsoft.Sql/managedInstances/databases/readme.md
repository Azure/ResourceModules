# SQL Managed Instances Database `[Microsoft.Sql/managedInstances/databases]`

This template deploys a SQL Managed Instances Database.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Sql/managedInstances/databases` | 2021-05-01-preview |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | 2021-02-01-preview |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | 2017-03-01-preview |

### Deployment prerequisites

The SQL Managed Instance Database is deployed on a SQL Managed Instance.

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backupLongTermRetentionPoliciesObj` | _[backupLongTermRetentionPolicies](backupLongTermRetentionPolicies/readme.md)_ object | `{object}` |  | Optional. The configuration for the backup long term retention policy definition |
| `backupShortTermRetentionPoliciesObj` | _[backupShortTermRetentionPolicies](backupShortTermRetentionPolicies/readme.md)_ object | `{object}` |  | Optional. The configuration for the backup short term retention policy definition |
| `catalogCollation` | string | `SQL_Latin1_General_CP1_CI_AS` |  | Optional. Collation of the managed instance. |
| `collation` | string | `SQL_Latin1_General_CP1_CI_AS` |  | Optional. Collation of the managed instance database. |
| `createMode` | string | `Default` | `[Default, RestoreExternalBackup, PointInTimeRestore, Recovery, RestoreLongTermRetentionBackup]` | Optional. Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[SQLInsights, QueryStoreRuntimeStatistics, QueryStoreWaitStatistics, Errors]` | `[SQLInsights, QueryStoreRuntimeStatistics, QueryStoreWaitStatistics, Errors]` | Optional. The name of logs that will be streamed. |
| `longTermRetentionBackupResourceId` | string |  |  | Optional. Conditional. The name of the Long Term Retention backup to be used for restore of this managed database. |
| `managedInstanceName` | string |  |  | Required. The name of the SQL managed instance. |
| `name` | string |  |  | Required. The name of the SQL managed instance database. |
| `recoverableDatabaseId` | string |  |  | Optional. Conditional. The resource identifier of the recoverable database associated with create operation of this database. |
| `restorableDroppedDatabaseId` | string |  |  | Optional. Conditional. The restorable dropped database resource ID to restore when creating this database. |
| `restorePointInTime` | string |  |  | Optional. Conditional. If createMode is PointInTimeRestore, this value is required. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. |
| `sourceDatabaseId` | string |  |  | Optional. Conditional. The resource identifier of the source database associated with create operation of this database. |
| `storageContainerSasToken` | string |  |  | Optional. Conditional. If createMode is RestoreExternalBackup, this value is required. Specifies the storage container sas token. |
| `storageContainerUri` | string |  |  | Optional. Conditional. If createMode is RestoreExternalBackup, this value is required. Specifies the uri of the storage container where backups for this restore are stored. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics. |

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `databaseName` | string | The name of the deployed database |
| `databaseResourceGroup` | string | The resource group the database was deployed into |
| `databaseResourceId` | string | The resource ID of the deployed database |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Managedinstances/Databases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/databases)
- [Managedinstances/Databases/Backuplongtermretentionpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/databases/backupLongTermRetentionPolicies)
- [Managedinstances/Databases/Backupshorttermretentionpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-03-01-preview/managedInstances/databases/backupShortTermRetentionPolicies)

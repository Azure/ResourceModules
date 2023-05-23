# SQL Managed Instances Database `[Microsoft.Sql/managedInstances/databases]`

This template deploys a SQL Managed Instances Database.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Sql/managedInstances/databases` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/managedInstances/databases) |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/managedInstances/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/managedInstances/databases/backupShortTermRetentionPolicies) |

### Deployment prerequisites

The SQL Managed Instance Database is deployed on a SQL Managed Instance.

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the SQL managed instance database. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `longTermRetentionBackupResourceId` | string | `''` | The resource ID of the Long Term Retention backup to be used for restore of this managed database. Required if createMode is RestoreLongTermRetentionBackup. |
| `managedInstanceName` | string |  | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |
| `recoverableDatabaseId` | string | `''` | The resource identifier of the recoverable database associated with create operation of this database. Required if createMode is Recovery. |
| `restorePointInTime` | string | `''` | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. Required if createMode is PointInTimeRestore. |
| `sourceDatabaseId` | string | `''` | The resource identifier of the source database associated with create operation of this database. Required if createMode is PointInTimeRestore. |
| `storageContainerSasToken` | string | `''` | Specifies the storage container sas token. Required if createMode is RestoreExternalBackup. |
| `storageContainerUri` | string | `''` | Specifies the uri of the storage container where backups for this restore are stored. Required if createMode is RestoreExternalBackup. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backupLongTermRetentionPoliciesObj` | _[backupLongTermRetentionPolicies](backup-long-term-retention-policies/README.md)_ object | `{object}` |  | The configuration for the backup long term retention policy definition. |
| `backupShortTermRetentionPoliciesObj` | _[backupShortTermRetentionPolicies](backup-short-term-retention-policies/README.md)_ object | `{object}` |  | The configuration for the backup short term retention policy definition. |
| `catalogCollation` | string | `'SQL_Latin1_General_CP1_CI_AS'` |  | Collation of the managed instance. |
| `collation` | string | `'SQL_Latin1_General_CP1_CI_AS'` |  | Collation of the managed instance database. |
| `createMode` | string | `'Default'` | `[Default, PointInTimeRestore, Recovery, RestoreExternalBackup, RestoreLongTermRetentionBackup]` | Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. RestoreLongTermRetentionBackup: Create a database by restoring from a long term retention backup (longTermRetentionBackupResourceId required). |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, Errors, QueryStoreRuntimeStatistics, QueryStoreWaitStatistics, SQLInsights]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `restorableDroppedDatabaseId` | string | `''` |  | The restorable dropped database resource ID to restore when creating this database. |
| `tags` | object | `{object}` |  | Tags of the resource. |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed database. |
| `resourceGroupName` | string | The resource group the database was deployed into. |
| `resourceId` | string | The resource ID of the deployed database. |

## Cross-referenced modules

_None_

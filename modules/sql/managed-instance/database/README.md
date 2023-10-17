# SQL Managed Instance Databases `[Microsoft.Sql/managedInstances/databases]`

This module deploys a SQL Managed Instance Database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Sql/managedInstances/databases` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/databases) |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/databases/backupShortTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the SQL managed instance database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`longTermRetentionBackupResourceId`](#parameter-longtermretentionbackupresourceid) | string | The resource ID of the Long Term Retention backup to be used for restore of this managed database. Required if createMode is RestoreLongTermRetentionBackup. |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |
| [`recoverableDatabaseId`](#parameter-recoverabledatabaseid) | string | The resource identifier of the recoverable database associated with create operation of this database. Required if createMode is Recovery. |
| [`restorePointInTime`](#parameter-restorepointintime) | string | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. Required if createMode is PointInTimeRestore. |
| [`sourceDatabaseId`](#parameter-sourcedatabaseid) | string | The resource identifier of the source database associated with create operation of this database. Required if createMode is PointInTimeRestore. |
| [`storageContainerSasToken`](#parameter-storagecontainersastoken) | string | Specifies the storage container sas token. Required if createMode is RestoreExternalBackup. |
| [`storageContainerUri`](#parameter-storagecontaineruri) | string | Specifies the uri of the storage container where backups for this restore are stored. Required if createMode is RestoreExternalBackup. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupLongTermRetentionPoliciesObj`](#parameter-backuplongtermretentionpoliciesobj) | object | The configuration for the backup long term retention policy definition. |
| [`backupShortTermRetentionPoliciesObj`](#parameter-backupshorttermretentionpoliciesobj) | object | The configuration for the backup short term retention policy definition. |
| [`catalogCollation`](#parameter-catalogcollation) | string | Collation of the managed instance. |
| [`collation`](#parameter-collation) | string | Collation of the managed instance database. |
| [`createMode`](#parameter-createmode) | string | Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. RestoreLongTermRetentionBackup: Create a database by restoring from a long term retention backup (longTermRetentionBackupResourceId required). |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`restorableDroppedDatabaseId`](#parameter-restorabledroppeddatabaseid) | string | The restorable dropped database resource ID to restore when creating this database. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `backupLongTermRetentionPoliciesObj`

The configuration for the backup long term retention policy definition.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `backupShortTermRetentionPoliciesObj`

The configuration for the backup short term retention policy definition.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `catalogCollation`

Collation of the managed instance.
- Required: No
- Type: string
- Default: `'SQL_Latin1_General_CP1_CI_AS'`

### Parameter: `collation`

Collation of the managed instance database.
- Required: No
- Type: string
- Default: `'SQL_Latin1_General_CP1_CI_AS'`

### Parameter: `createMode`

Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. RestoreLongTermRetentionBackup: Create a database by restoring from a long term retention backup (longTermRetentionBackupResourceId required).
- Required: No
- Type: string
- Default: `'Default'`
- Allowed: `[Default, PointInTimeRestore, Recovery, RestoreExternalBackup, RestoreLongTermRetentionBackup]`

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, Errors, QueryStoreRuntimeStatistics, QueryStoreWaitStatistics, SQLInsights]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `longTermRetentionBackupResourceId`

The resource ID of the Long Term Retention backup to be used for restore of this managed database. Required if createMode is RestoreLongTermRetentionBackup.
- Required: No
- Type: string
- Default: `''`

### Parameter: `managedInstanceName`

The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `name`

The name of the SQL managed instance database.
- Required: Yes
- Type: string

### Parameter: `recoverableDatabaseId`

The resource identifier of the recoverable database associated with create operation of this database. Required if createMode is Recovery.
- Required: No
- Type: string
- Default: `''`

### Parameter: `restorableDroppedDatabaseId`

The restorable dropped database resource ID to restore when creating this database.
- Required: No
- Type: string
- Default: `''`

### Parameter: `restorePointInTime`

Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. Required if createMode is PointInTimeRestore.
- Required: No
- Type: string
- Default: `''`

### Parameter: `sourceDatabaseId`

The resource identifier of the source database associated with create operation of this database. Required if createMode is PointInTimeRestore.
- Required: No
- Type: string
- Default: `''`

### Parameter: `storageContainerSasToken`

Specifies the storage container sas token. Required if createMode is RestoreExternalBackup.
- Required: No
- Type: string
- Default: `''`

### Parameter: `storageContainerUri`

Specifies the uri of the storage container where backups for this restore are stored. Required if createMode is RestoreExternalBackup.
- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed database. |
| `resourceGroupName` | string | The resource group the database was deployed into. |
| `resourceId` | string | The resource ID of the deployed database. |

## Cross-referenced modules

_None_

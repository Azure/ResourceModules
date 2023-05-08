# SQL Server Database `[Microsoft.Sql/servers/databases]`

This module deploys an Azure SQL Server Database.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Sql/servers/databases` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-11-01/servers/databases) |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupShortTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the database. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `serverName` | string | The name of the parent SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoPauseDelay` | int | `0` |  | Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. |
| `backupLongTermRetentionPolicy` | object | `{object}` |  | The long term backup retention policy to create for the database. |
| `backupShortTermRetentionPolicy` | object | `{object}` |  | The short term backup retention policy to create for the database. |
| `collation` | string | `'SQL_Latin1_General_CP1_CI_AS'` |  | The collation of the database. |
| `createMode` | string | `'Default'` | `[Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreLongTermRetentionBackup, Secondary]` | Specifies the mode of database creation. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, AutomaticTuning, Blocks, DatabaseWaitStatistics, Deadlocks, DevOpsOperationsAudit, Errors, QueryStoreRuntimeStatistics, QueryStoreWaitStatistics, SQLInsights, SQLSecurityAuditEvents, Timeouts]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[Basic, InstanceAndAppAdvanced, WorkloadManagement]` | `[Basic, InstanceAndAppAdvanced, WorkloadManagement]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `elasticPoolId` | string | `''` |  | The resource ID of the elastic pool containing this database. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `highAvailabilityReplicaCount` | int | `0` |  | The number of readonly secondary replicas associated with the database. |
| `isLedgerOn` | bool | `False` |  | Whether or not this database is a ledger database, which means all tables in the database are ledger tables. Note: the value of this property cannot be changed after the database has been created. |
| `licenseType` | string | `''` |  | The license type to apply for this database. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `maintenanceConfigurationId` | string | `''` |  | Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur. |
| `maxSizeBytes` | int | `34359738368` |  | The max size of the database expressed in bytes. |
| `minCapacity` | string | `''` |  | Minimal capacity that database will always have allocated. |
| `readScale` | string | `'Disabled'` | `[Disabled, Enabled]` | The state of read-only routing. |
| `recoveryServicesRecoveryPointResourceId` | string | `''` |  | Resource ID of backup if createMode set to RestoreLongTermRetentionBackup. |
| `requestedBackupStorageRedundancy` | string | `''` | `['', Geo, Local, Zone]` | The storage account type to be used to store backups for this database. |
| `restorePointInTime` | string | `''` |  | Point in time (ISO8601 format) of the source database to restore when createMode set to Restore or PointInTimeRestore. |
| `sampleName` | string | `''` |  | The name of the sample schema to apply when creating this database. |
| `skuCapacity` | int | `-1` |  | Capacity of the particular SKU. |
| `skuFamily` | string | `''` |  | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| `skuName` | string | `'GP_Gen5_2'` |  | The name of the SKU. |
| `skuSize` | string | `''` |  | Size of the particular SKU. |
| `skuTier` | string | `'GeneralPurpose'` |  | The skuTier or edition of the particular SKU. |
| `sourceDatabaseDeletionDate` | string | `''` |  | The time that the database was deleted when restoring a deleted database. |
| `sourceDatabaseResourceId` | string | `''` |  | Resource ID of database if createMode set to Copy, Secondary, PointInTimeRestore, Recovery or Restore. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `zoneRedundant` | bool | `False` |  | Whether or not this database is zone redundant. |


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
| `resourceGroupName` | string | The resource group of the deployed database. |
| `resourceId` | string | The resource ID of the deployed database. |

## Cross-referenced modules

_None_

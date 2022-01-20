# SQL Server Database `[Microsoft.Sql/servers/databases]`

This module deploys an Azure SQL Server.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Sql/servers/databases` | 2021-02-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoPauseDelay` | string |  |  | Optional. Time in minutes after which database is automatically paused. |
| `collation` | string |  |  | Optional. The collation of the database. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. |
| `highAvailabilityReplicaCount` | int |  |  | Optional. The number of readonly secondary replicas associated with the database. |
| `isLedgerOn` | bool |  |  | Optional. Whether or not this database is a ledger database, which means all tables in the database are ledger tables. Note: the value of this property cannot be changed after the database has been created. |
| `licenseType` | string |  |  | Optional. The license type to apply for this database. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `logsToEnable` | array | `[SQLInsights, AutomaticTuning, QueryStoreRuntimeStatistics, QueryStoreWaitStatistics, Errors, DatabaseWaitStatistics, Timouts, Blocks, Deadlocks]` | `[SQLInsights, AutomaticTuning, QueryStoreRuntimeStatistics, QueryStoreWaitStatistics, Errors, DatabaseWaitStatistics, Timouts, Blocks, Deadlocks]` | Optional. The name of logs that will be streamed. |
| `maintenanceConfigurationId` | string |  |  | Optional. Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur. |
| `maxSizeBytes` | int |  |  | Optional. The max size of the database expressed in bytes. |
| `metricsToEnable` | array | `[Basic]` | `[Basic]` | Optional. The name of metrics that will be streamed. |
| `minCapacity` | string |  |  | Optional. Minimal capacity that database will always have allocated. |
| `name` | string |  |  | Required. The name of the database. |
| `readScale` | string | `Disabled` | `[Enabled, Disabled]` | Optional. The state of read-only routing. |
| `requestedBackupStorageRedundancy` | string |  | `[Geo, Local, Zone, ]` | Optional. The storage account type to be used to store backups for this database. |
| `sampleName` | string |  |  | Optional. The name of the sample schema to apply when creating this database. |
| `serverName` | string |  |  | Required. The Name of SQL Server |
| `skuName` | string |  |  | Required. The name of the SKU. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `tier` | string |  |  | Optional. The tier or edition of the particular SKU. |
| `zoneRedundant` | bool |  |  | Optional. Whether or not this database is zone redundant. |

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
| `name` | string | The name of the deployed database |
| `resourceGroupName` | string | The resourceGroup of the deployed database |
| `resourceId` | string | The resource ID of the deployed database |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Servers/Databases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/servers/databases)

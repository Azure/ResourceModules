# SQL Managed Instances Database

This template deploys an SQL Managed Instances Database.


## Resource types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Sql/managedInstances/databases`|2019-06-01-preview|
|`Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies`|2017-03-01-preview|
|`Microsoft.Sql/managedInstances/databases/providers/diagnosticsettings`|2017-05-01-preview|
|`providers/locks`|2016-09-01|
|`Microsoft.Resources/deployments`|2018-02-01|


### Deployment prerequisites

The SQL Managed Instance Database is deployed on a SQL Managed Instance.

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `backupLongTermRetentionPoliciesName` | string | Required. The name of the Long Term Retention backup policy. | LTRdefault | |
| `backupShortTermRetentionPoliciesName` | string | Required. The name of the Short Term Retention backup policy. | Default |  |
| `catalogCollation` | string | Optional. Collation of the managed instance. | SQL_Latin1_General_CP1_CI_AS | |
| `collation` | string | Optional. Collation of the managed instance database. | SQL_Latin1_General_CP1_CI_AS | |
| `createMode` | string | Optional. Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. | Default | |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  | |
| `databaseName` | string | Required. The name of the SQL managed instance database. |  | |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 | |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  | |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  | |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  | |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] | |
| `lockForDeletion` | bool | Optional. Switch to lock Key Vault from deletion. | False | |
| `longTermRetentionBackupResourceId` | string | Optional. Conditional. The name of the Long Term Retention backup to be used for restore of this managed database. |  | |
| `managedInstanceName` | string | Required. The name of the SQL managed instance. |  | |
| `monthlyRetention` | string | Required. The monthly retention policy for an LTR backup in an ISO 8601 format. | P1Y | |
| `recoverableDatabaseId` | string | Optional. Conditional. The resource identifier of the recoverable database associated with create operation of this database. |  | |
| `restorableDroppedDatabaseId` | string | Optional. Conditional. The restorable dropped database resource id to restore when creating this database. |  | |
| `restorePointInTime` | string | Optional. Conditional. If createMode is PointInTimeRestore, this value is required. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. |  | |
| `retentionDays` | int | Required. The backup retention period in days. This is how many days Point-in-Time Restore will be supported. | 35 | |
| `sourceDatabaseId` | string | Optional. Conditional. The resource identifier of the source database associated with create operation of this database. |  | |
| `storageContainerSasToken` | string | Optional. Conditional. If createMode is RestoreExternalBackup, this value is required. Specifies the storage container sas token. |  | |
| `storageContainerUri` | string | Optional. Conditional. If createMode is RestoreExternalBackup, this value is required. Specifies the uri of the storage container where backups for this restore are stored. |  | |
| `tags` | object | Optional. Tags of the resource. |  | |
| `weeklyRetention` | string | Required. The weekly retention policy for an LTR backup in an ISO 8601 format. | P1M | |
| `weekOfYear` | int | Required. The week of year to take the yearly backup in an ISO 8601 format. | 5 | |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  | |
| `yearlyRetention` | string | Required. The yearly retention policy for an LTR backup in an ISO 8601 format. | P5Y | |

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

""`json
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
""`
### Parameter Usage: `LongTermRetention`

""`json
{
  "name": "default",
  "type": "Microsoft.Sql/resourceGroups/servers/databases/backupLongTermRetentionPolicies",
  "properties": {
    "weeklyRetention": "P1M",
    "monthlyRetention": "P1Y",
    "yearlyRetention": "P5Y",
    "weekOfYear": 5
  }
}
""`

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `managedInstanceName` | string | The name of the SQL managed instance. |
| `managedInstanceResourceGroup` | string | The Resource Group in which the resource has been created. |
| `managedInstanceResourceId` | string | The Resource ID of the Manged Instance. |

## Considerations

*N/A*


## Additional resources

- [Introduction to Azure SQL Managed Instance](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-managed-instance-index)
- [ARM Template schema for SQL Managed Instance Database](https://docs.microsoft.com/en-us/azure/templates/microsoft.sql/2019-06-01-preview/managedinstances/databases)
- [ARM Template schema for SQL Managed Instance](https://docs.microsoft.com/en-us/azure/templates/microsoft.sql/2018-06-01-preview/managedinstances)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
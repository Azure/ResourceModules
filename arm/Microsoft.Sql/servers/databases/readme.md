# SQL Server Database `[Microsoft.Sql/servers/databases]`

This module deploys an Azure SQL Server.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/databases` | 2021-02-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoPauseDelay` | string |  |  | Optional. Time in minutes after which database is automatically paused. |
| `collation` | string |  |  | Optional. The collation of the database. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `highAvailabilityReplicaCount` | int |  |  | Optional. The number of readonly secondary replicas associated with the database. |
| `isLedgerOn` | bool |  |  | Optional. Whether or not this database is a ledger database, which means all tables in the database are ledger tables. Note: the value of this property cannot be changed after the database has been created. |
| `licenseType` | string |  |  | Optional. The license type to apply for this database. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `maintenanceConfigurationId` | string |  |  | Optional. Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur. |
| `maxSizeBytes` | int |  |  | Optional. The max size of the database expressed in bytes. |
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
| `databaseName` | string | The name of the deployed database |
| `databaseResourceGroup` | string | The resourceGroup of the deployed database |
| `databaseResourceId` | string | The resource ID of the deployed database |

## Template references

- [Servers/Databases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/servers/databases)

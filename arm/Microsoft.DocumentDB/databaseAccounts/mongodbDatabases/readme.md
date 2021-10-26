# DocumentdbDatabaseaccountsMongodbdatabases

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | 2021-07-01-preview |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/throughputSettings` | 2021-07-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `databaseAccountName` | string |  |  | Required. Name of the Cosmos DB database account. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for the resources. |
| `maxThroughput` | int | `4000` |  | Required. Name of the mongodb database |
| `mongodbDatabaseName` | string |  |  | Required. Name of the mongodb database |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `throughput` | int | `400` |  | Optional. Name of the mongodb database |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `mongodbDatabaseName` | string | The name of the mongodb database. |
| `mongodbDatabaseResourceGroup` | string | The name of the Resource Group the mongodb database was created in. |
| `mongodbDatabaseResourceId` | string | The Resource Id of the mongodb database. |

## Template references

- [Databaseaccounts/Mongodbdatabases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/mongodbDatabases)
- [Databaseaccounts/Mongodbdatabases/Throughputsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/mongodbDatabases/throughputSettings)

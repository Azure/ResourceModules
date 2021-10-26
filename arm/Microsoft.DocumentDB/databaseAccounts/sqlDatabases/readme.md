# DocumentdbDatabaseaccountsSQLdbdatabases

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | 2021-06-15 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `databaseAccountName` | string |  |  | Required. Id of the Cosmos DB database account. |
| `sqlDatabaseName` | string |  |  | Required. Name of the SQL Database  |
| `tags` | object | `{object}` |  | Optional. Tags of the SQL Database resource. |
| `throughput` | int | `400` |  | Optional. Name of the mongodb database |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `sqlDatabaseName` | string | The name of the sql database. |
| `sqlDatabaseResourceGroup` | string | The name of the Resource Group the sql database was created in. |
| `sqlDatabaseResourceId` | string | The Resource Id of the sql database. |

## Template references

- [Databaseaccounts/Sqldatabases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-06-15/databaseAccounts/sqlDatabases)

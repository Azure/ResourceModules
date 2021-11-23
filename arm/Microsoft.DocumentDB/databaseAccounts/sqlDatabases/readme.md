# DocumentDB Database Account SQL Databases `[Microsoft.DocumentDB/databaseAccount/sqlDatabases]`

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | 2021-06-15 |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | 2021-07-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `containers` | _[containers](containers/readme.md)_ array | `[]` |  | Optional. Array of containers to deploy in the SQL database. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `databaseAccountName` | string |  |  | Required. ID of the Cosmos DB database account. |
| `name` | string |  |  | Required. Name of the SQL Database  |
| `tags` | object | `{object}` |  | Optional. Tags of the SQL Database resource. |
| `throughput` | int | `400` |  | Optional. Request Units per second |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `sqlDatabaseName` | string | The name of the sql database. |
| `sqlDatabaseResourceGroup` | string | The name of the Resource Group the sql database was created in. |
| `sqlDatabaseResourceId` | string | The Resource ID of the sql database. |

## Template references

- [Databaseaccounts/Sqldatabases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-06-15/databaseAccounts/sqlDatabases)
- [Databaseaccounts/Sqldatabases/Containers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/sqlDatabases/containers)

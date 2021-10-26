# DocumentdbDatabaseaccountsSqldatabasesContainers

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | 2021-07-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `containerName` | string |  |  | Required. Name of the container. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `sqlDatabaseName` | string |  |  | Required. Name of the SQL Database  |
| `tags` | object | `{object}` |  | Optional. Tags of the SQL Database resource. |
| `throughput` | int | `400` |  | Optional. Request Units per second |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `containerName` | string | The name of the container. |
| `containerResourceGroup` | string | The name of the Resource Group the container was created in. |
| `containerResourceId` | string | The Resource Id of the container. |

## Template references

- [Databaseaccounts/Sqldatabases/Containers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/sqlDatabases/containers)

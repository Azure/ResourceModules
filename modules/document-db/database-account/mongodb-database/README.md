# DocumentDB Database Account MongoDB Databases `[Microsoft.DocumentDB/databaseAccounts/mongodbDatabases]`

This module deploys a MongoDB Database within a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/mongodbDatabases/collections) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the mongodb database. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `databaseAccountName` | string | The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `collections` | array | `[]` | Collections in the mongodb database. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `tags` | object | `{object}` | Tags of the resource. |
| `throughput` | int | `400` | Name of the mongodb database. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the mongodb database. |
| `resourceGroupName` | string | The name of the resource group the mongodb database was created in. |
| `resourceId` | string | The resource ID of the mongodb database. |

## Cross-referenced modules

_None_

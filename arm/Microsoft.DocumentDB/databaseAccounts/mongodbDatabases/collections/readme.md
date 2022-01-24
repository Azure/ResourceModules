# DocumentDB Database Account MongoDB databases Collections `[Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections]`

This module deploys a collection within a MongoDB.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | 2021-07-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `databaseAccountName` | string |  |  | Required. Name of the Cosmos DB database account. |
| `indexes` | array |  |  | Required. Indexes for the collection |
| `mongodbDatabaseName` | string |  |  | Required. Name of the mongodb database |
| `name` | string |  |  | Required. Name of the collection |
| `shardKey` | object |  |  | Required. ShardKey for the collection |
| `throughput` | int | `400` |  | Optional. Name of the mongodb database |

### Parameter Usage: `indexes`

Array of index keys as MongoIndex. The array contains keys for each MongoDB collection in the Azure Cosmos DB service with a collection resource object (as `key`) and collection index options (as `options`).

```json
    "indexes": {
        "value": [
            {
                "key": {
                    "keys": [
                        "_id"
                    ]
                }
            },
            {
                "key": {
                    "keys": [
                        "$**"
                    ]
                }
            },
            {
                "key": {
                    "keys": [
                        "estate_id",
                        "estate_address"
                    ]
                },
                "options": {
                    "unique": true
                }
            },
            {
                "key": {
                    "keys": [
                        "_ts"
                    ]
                },
                "options": {
                    "expireAfterSeconds": 2629746
                }
            }
        ]
    }
```

### Parameter Usage: `shardKey`

The shard key and partition kind pair, only support "Hash" partition kind.

```json
    "shardKey": {
        "value": {
            "estate_id": "Hash"
        }
    }
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the mongodb database. |
| `resourceGroupName` | string | The name of the resource group the mongodb database was created in. |
| `resourceId` | string | The resource ID of the mongodb database. |

## Template references

- [Databaseaccounts/Mongodbdatabases/Collections](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/mongodbDatabases/collections)

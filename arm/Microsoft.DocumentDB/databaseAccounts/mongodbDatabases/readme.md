# DocumentDB Database Account MongoDB databases `[Microsoft.DocumentDB/databaseAccounts/mongodbDatabases]`

This module deploys a MongoDB within a CosmosDB account.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | 2021-07-01-preview |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | 2021-07-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `collections` | _[collections](collections/readme.md)_ array | `[]` |  | Optional. Collections in the mongodb database |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `databaseAccountName` | string |  |  | Required. Name of the Cosmos DB database account. |
| `name` | string |  |  | Required. Name of the mongodb database |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `throughput` | int | `400` |  | Optional. Name of the mongodb database |

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

### Parameter Usage: `collections`

Please reference the documentation for [collections](./collections/readme.md)

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the mongodb database. |
| `resourceGroupName` | string | The name of the resource group the mongodb database was created in. |
| `resourceId` | string | The resource ID of the mongodb database. |

## Template references

- [Databaseaccounts/Mongodbdatabases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/mongodbDatabases)
- [Databaseaccounts/Mongodbdatabases/Collections](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/mongodbDatabases/collections)

# DocumentDB Database Account Gremlin databases `[Microsoft.DocumentDB/databaseAccounts/gremlinDatabases]`

This module deploys a GremlinDB within a CosmosDB account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2022-02-15-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2022-02-15-preview/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2022-02-15-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2022-02-15-preview/databaseAccounts/gremlinDatabases/collections) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the gremlin database. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `databaseAccountName` | string | The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `graphs` | _[collections](collections/readme.md)_ array | `[]` | Collections in the gremlin database. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `tags` | object | `{object}` | Tags of the resource. |
| `throughput` | int | `400` | Name of the gremlin database. |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter Usage: `graphs`

Please reference the documentation for [graphs](./graphs/readme.md)

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the gremlin database. |
| `resourceGroupName` | string | The name of the resource group the gremlin database was created in. |
| `resourceId` | string | The resource ID of the gremlin database. |

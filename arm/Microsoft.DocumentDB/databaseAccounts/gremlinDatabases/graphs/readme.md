# DocumentDB DatabaseAccounts GremlinDatabases Graphs `[Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs]`

This module deploys DocumentDB DatabaseAccounts GremlinDatabases Graphs.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2022-02-15-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2022-02-15-preview/databaseAccounts/gremlinDatabases/graphs) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the graph. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `databaseAccountName` | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |
| `gremlinDatabaseName` | string | The name of the parent Gremlin Database. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `automaticIndexing` | bool | `True` |  | Indicates if the indexing policy is automatic. |
| `enableDefaultTelemetry` | bool | `False` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `indexingMode` | string | `'consistent'` | `[consistent, lazy, none]` | Indicates the indexing mode. |
| `indexingPaths` | array | `[]` |  | List of paths to include in the indexing. Sets the `includedPaths` property. |
| `kind` | string | `'Hash'` | `[Hash, MultiHash, Range]` | Indicates the kind of algorithm used for partitioning. For MultiHash, multiple partition keys (up to three maximum) are supported for container create. |
| `maxThroughput` | int | `0` |  | Represents maximum throughput, the resource can scale up to. |
| `partitionKeyPaths` | array | `[]` |  | List of paths using which data within the container can be partitioned. |
| `tags` | object | `{object}` |  | Tags of the Gremlin graph resource. |
| `throughput` | int | `0` |  | Request Units per second. For example, "throughput": 10000. |
| `uniqueKeyPaths` | array | `[]` |  | List of paths must be unique for each document in the Azure Cosmos DB service. |


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

### Parameter Usage: `indexingPaths`, `partitionKeyPaths`, `uniqueKeyPaths`

Different kinds of paths can be provided as array of strings:

<details>

<summary>Bicep format</summary>

```bicep
graphs: [
  {
    name: 'graph01'
    automaticIndexing: true
    partitionKeyPaths: [
      '/name'
    ],
    
  }
  {
    name: 'graph02'
    automaticIndexing: true
    partitionKeyPaths: [
      '/address'
    ]
  }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the graph. |
| `resourceGroupName` | string | The name of the resource group the graph was created in. |
| `resourceId` | string | The resource ID of the graph. |

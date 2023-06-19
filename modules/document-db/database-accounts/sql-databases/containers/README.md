# DocumentDB Database Account SQL Database Containers `[Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers]`

This module deploys a SQL Database Container in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlDatabases/containers) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the container. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `databaseAccountName` | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |
| `sqlDatabaseName` | string | The name of the parent SQL Database. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `analyticalStorageTtl` | int | `0` |  | Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store. |
| `autoscaleSettingsMaxThroughput` | int | `-1` |  | Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to -1, then the property will be set to null and autoscale will be disabled. |
| `conflictResolutionPolicy` | object | `{object}` |  | The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions. |
| `defaultTtl` | int | `-1` |  | Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items dont expire by default. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `indexingPolicy` | object | `{object}` |  | Indexing policy of the container. |
| `kind` | string | `'Hash'` | `[Hash, MultiHash, Range]` | Indicates the kind of algorithm used for partitioning. |
| `paths` | array | `[]` |  | List of paths using which data within the container can be partitioned. |
| `tags` | object | `{object}` |  | Tags of the SQL Database resource. |
| `throughput` | int | `400` |  | Request Units per second. Will be set to null if autoscaleSettingsMaxThroughput is used. |
| `uniqueKeyPolicyKeys` | array | `[]` |  | The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service. |


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

### Parameter Usage: `indexingPolicy`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"indexingPolicy": {
    "indexingMode": "consistent",
    "includedPaths": [
        {
            "path": "/*"
        }
    ],
    "excludedPaths": [
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
indexingPolicy: {
    indexingMode: 'consistent'
    includedPaths: [
    {
        path: '/*'
    }
    ]
    excludedPaths: []
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the container. |
| `resourceGroupName` | string | The name of the resource group the container was created in. |
| `resourceId` | string | The resource ID of the container. |

## Cross-referenced modules

_None_

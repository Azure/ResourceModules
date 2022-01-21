# DocumentDB Database Account SQL Databases Containers `[Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers]`

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | 2021-07-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `databaseAccountName` | string |  |  | Required. Name of the Database Account |
| `kind` | string | `Hash` | `[Hash, MultiHash, Range]` | Optional. Indicates the kind of algorithm used for partitioning |
| `name` | string |  |  | Required. Name of the container. |
| `paths` | array | `[]` |  | Optional. List of paths using which data within the container can be partitioned |
| `sqlDatabaseName` | string |  |  | Required. Name of the SQL Database  |
| `tags` | object | `{object}` |  | Optional. Tags of the SQL Database resource. |
| `throughput` | int | `400` |  | Optional. Request Units per second |

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the container. |
| `resourceGroupName` | string | The name of the resource group the container was created in. |
| `resourceId` | string | The resource ID of the container. |

## Template references

- [Databaseaccounts/Sqldatabases/Containers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/sqlDatabases/containers)

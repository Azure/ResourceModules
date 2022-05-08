# DocumentDB Database Account SQL Databases `[Microsoft.DocumentDB/databaseAccounts/sqlDatabases]`

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2021-06-15](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-06-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2021-07-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/sqlDatabases/containers) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the SQL database . |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `databaseAccountName` | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `containers` | _[containers](containers/readme.md)_ array | `[]` | Array of containers to deploy in the SQL database. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `tags` | object | `{object}` | Tags of the SQL database resource. |
| `throughput` | int | `400` | Request units per second. |


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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the SQL database. |
| `resourceGroupName` | string | The name of the resource group the SQL database was created in. |
| `resourceId` | string | The resource ID of the SQL database. |

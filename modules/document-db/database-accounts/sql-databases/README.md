# DocumentDB Database Account SQL Databases `[Microsoft.DocumentDB/databaseAccounts/sqlDatabases]`

This module deploys a SQL Database within a CosmosDB account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlDatabases/containers) |

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
| `autoscaleSettingsMaxThroughput` | int | `-1` | Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to.  The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to -1, then the property will be set to null and autoscale will be disabled. |
| `containers` | _[containers](containers/README.md)_ array | `[]` | Array of containers to deploy in the SQL database. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `tags` | object | `{object}` | Tags of the SQL database resource. |
| `throughput` | int | `400` | Request units per second. Will be set to null if autoscaleSettingsMaxThroughput is used. |


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

## Cross-referenced modules

_None_

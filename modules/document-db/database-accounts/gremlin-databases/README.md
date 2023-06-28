# DocumentDB Database Account Gremlin Databases `[Microsoft.DocumentDB/databaseAccounts/gremlinDatabases]`

This module deploys a Gremlin Database within a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/gremlinDatabases/graphs) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Gremlin database. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `databaseAccountName` | string | The name of the parent Gremlin database. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `graphs` | _[graphs](graphs/README.md)_ array | `[]` | Array of graphs to deploy in the Gremlin database. |
| `maxThroughput` | int | `4000` | Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored. |
| `systemAssignedIdentity` | bool | `False` | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` | Tags of the Gremlin database resource. |
| `throughput` | int | `-1` | Request Units per second (for example 10000). Cannot be set together with `maxThroughput`. |
| `userAssignedIdentities` | object | `{object}` | The ID(s) to assign to the resource. |


### Parameter Usage: `graphs`

List of graph databaseAccounts

<details>

<summary>Parameter JSON format</summary>

```json
"graphs": {
  "value": [
    {
      "name": "graph01",
      "automaticIndexing": true,
      "partitionKeyPaths": [
        "/name"
      ]
    },
    {
      "name": "graph02",
      "automaticIndexing": true,
      "partitionKeyPaths": [
        "/name"
      ]
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
graphs: [
  {
    name: 'graph01'
    automaticIndexing: true
    partitionKeyPaths: [
      '/name'
    ]
  }
  {
    name: 'graph02'
    automaticIndexing: true
    partitionKeyPaths: [
      '/name'
    ]
  }
]
```

</details>

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

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Gremlin database. |
| `resourceGroupName` | string | The name of the resource group the Gremlin database was created in. |
| `resourceId` | string | The resource ID of the Gremlin database. |

## Cross-referenced modules

_None_

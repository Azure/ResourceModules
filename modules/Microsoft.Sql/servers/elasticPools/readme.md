# SQL Server Elastic Pool `[Microsoft.Sql/servers/elasticPools]`

This module deploys an Azure SQL Server Elastic Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/elasticPools` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/elasticPools) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Elastic Pool. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `serverName` | string | The name of the parent SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `databaseMaxCapacity` | int | `2` |  | The maximum capacity any one database can consume. |
| `databaseMinCapacity` | int | `0` |  | The minimum capacity all databases are guaranteed. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `highAvailabilityReplicaCount` | int | `-1` |  | The number of secondary replicas associated with the elastic pool that are used to provide high availability. Applicable only to Hyperscale elastic pools. |
| `licenseType` | string | `'LicenseIncluded'` | `[BasePrice, LicenseIncluded]` | The license type to apply for this elastic pool. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `maintenanceConfigurationId` | string | `''` |  | Maintenance configuration resource ID assigned to the elastic pool. This configuration defines the period when the maintenance updates will will occur. |
| `maxSizeBytes` | int | `34359738368` |  | The storage limit for the database elastic pool in bytes. |
| `minCapacity` | int | `2` |  | Minimal capacity that serverless pool will not shrink below, if not paused. |
| `skuCapacity` | int | `2` |  | Capacity of the particular SKU. |
| `skuName` | string | `'GP_Gen5'` |  | The name of the SKU, typically, a letter + Number code, e.g. P3. |
| `skuTier` | string | `'GeneralPurpose'` |  | The tier or edition of the particular SKU, e.g. Basic, Premium. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `zoneRedundant` | bool | `False` |  | Whether or not this elastic pool is zone redundant, which means the replicas of this elastic pool will be spread across multiple availability zones. |


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
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed Elastic Pool. |
| `resourceGroupName` | string | The resource group of the deployed Elastic Pool. |
| `resourceId` | string | The resource ID of the deployed Elastic Pool. |

## Cross-referenced modules

_None_

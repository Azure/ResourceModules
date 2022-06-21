# ContainerRegistry Registries Replications `[Microsoft.ContainerRegistry/registries/replications]`

This module deploys ContainerRegistry Registries Replications.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerRegistry/registries/replications` | [2021-12-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2021-12-01-preview/registries/replications) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `registryName` | string | The name of the parent registry. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `regionEndpointEnabled` | bool | `True` |  | Specifies whether the replication regional endpoint is enabled. Requests will not be routed to a replication whose regional endpoint is disabled, however its data will continue to be synced with other replications. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `zoneRedundancy` | string | `'Disabled'` | `[Disabled, Enabled]` | Whether or not zone redundancy is enabled for this container registry. |


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
| `name` | string | The name of the replication. |
| `resourceGroupName` | string | The name of the resource group the replication was created in. |
| `resourceId` | string | The resource ID of the replication. |

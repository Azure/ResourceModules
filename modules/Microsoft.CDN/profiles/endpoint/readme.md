# CDN Profiles Endpoint `[Microsoft.CDN/profiles/endpoint]`

This module deploys CDN Profiles Endpoint.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/endpoints` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints) |
| `Microsoft.Cdn/profiles/endpoints/origins` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints/origins) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `endpointName` | string | Name of the endpoint under the profile which is unique globally. |
| `endpointProperties` | object | Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details). |
| `profileName` | string | Name of the CDN profile which is unique within the resource group. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Resource location. |
| `tags` | object | `{object}` | Endpoint tags. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

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
| `endpointProperties` | object | The properties of the endpoint. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The resource name. |
| `resourceGroupName` | string | The name of the resource group the Redis cache was created in. |
| `resourceId` | string | The resource ID. |

## Cross-referenced modules

_None_

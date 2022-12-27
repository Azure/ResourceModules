# DevTestLab Labs VirtualNetworks `[Microsoft.DevTestLab/labs/virtualNetworks]`

This module deploys DevTestLab Labs VirtualNetworks.

## Navigation

- [DevTestLab Labs VirtualNetworks `[Microsoft.DevTestLab/labs/virtualNetworks]`](#devtestlab-labs-virtualnetworks-microsoftdevtestlablabsvirtualnetworks)
  - [Navigation](#navigation)
  - [Resource Types](#resource-types)
  - [Parameters](#parameters)
    - [Parameter Usage: `tags`](#parameter-usage-tags)
  - [Outputs](#outputs)
  - [Cross-referenced modules](#cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/virtualnetworks` | [2018-10-15-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/labs/virtualnetworks) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `externalProviderResourceId` | string | The resource ID of the virtual network. |
| `name` | string | The name of the virtual network. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `labName` | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `allowedSubnets` | array | `[]` | The allowed subnets of the virtual network. |
| `description` | string | `''` | The description of the virtual network. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all Resources. |
| `subnetOverrides` | array | `[]` | The subnet overrides of the virtual network. |
| `tags` | object | `{object}` | Tags of the resource. |

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
| `name` | string | The name of the lab virtual network. |
| `resourceGroupName` | string | The name of the resource group the lab virtual network was created in. |
| `resourceId` | string | The resource ID of the lab virtual network. |

## Cross-referenced modules

_None_

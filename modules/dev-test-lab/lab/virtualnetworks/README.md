# DevTest Lab Virtual Networks `[Microsoft.DevTestLab/labs/virtualnetworks]`

This module deploys a DevTest Lab Virtual Network.

Lab virtual machines must be deployed into a virtual network. This resource type allows configuring the virtual network and subnet settings used for the lab virtual machines.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/virtualnetworks` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/virtualnetworks) |

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

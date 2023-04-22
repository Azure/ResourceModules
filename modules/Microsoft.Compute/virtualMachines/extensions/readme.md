# Virtual Machine Extensions `[Microsoft.Compute/virtualMachines/extensions]`

This module deploys a virtual machine extension.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Compute/virtualMachines/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `autoUpgradeMinorVersion` | bool | Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. |
| `enableAutomaticUpgrade` | bool | Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. |
| `name` | string | The name of the virtual machine extension. |
| `publisher` | string | The name of the extension handler publisher. |
| `type` | string | Specifies the type of the extension; an example is "CustomScriptExtension". |
| `typeHandlerVersion` | string | Specifies the version of the script handler. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `virtualMachineName` | string | The name of the parent virtual machine that extension is provisioned for. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `forceUpdateTag` | string | `''` | How the extension handler should be forced to update even if the extension configuration has not changed. |
| `location` | string | `[resourceGroup().location]` | The location the extension is deployed to. |
| `protectedSettings` | secureObject | `{object}` | Any object that contains the extension specific protected settings. |
| `settings` | object | `{object}` | Any object that contains the extension specific settings. |
| `supressFailures` | bool | `False` | Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false. |
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
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the extension. |
| `resourceGroupName` | string | The name of the Resource Group the extension was created in. |
| `resourceId` | string | The resource ID of the extension. |

## Cross-referenced modules

_None_

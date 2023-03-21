# virtual machine scale set Extensions `[Microsoft.Compute/virtualMachineScaleSets/extensions]`

This module deploys a virtual machine scale set extension.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Compute/virtualMachineScaleSets/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachineScaleSets/extensions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `autoUpgradeMinorVersion` | bool | Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. |
| `enableAutomaticUpgrade` | bool | Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. |
| `name` | string | The name of the virtual machine scale set extension. |
| `publisher` | string | The name of the extension handler publisher. |
| `type` | string | Specifies the type of the extension; an example is "CustomScriptExtension". |
| `typeHandlerVersion` | string | Specifies the version of the script handler. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `virtualMachineScaleSetName` | string | The name of the parent virtual machine scale set that extension is provisioned for. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `forceUpdateTag` | string | `''` | How the extension handler should be forced to update even if the extension configuration has not changed. |
| `protectedSettings` | secureObject | `{object}` | Any object that contains the extension specific protected settings. |
| `settings` | object | `{object}` | Any object that contains the extension specific settings. |
| `supressFailures` | bool | `False` | Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the extension. |
| `resourceGroupName` | string | The name of the Resource Group the extension was created in. |
| `resourceId` | string | The ResourceId of the extension. |

## Cross-referenced modules

_None_

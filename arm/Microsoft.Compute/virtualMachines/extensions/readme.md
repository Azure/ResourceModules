# Virtual Machine Extensions `[Microsoft.Compute/virtualMachines/extensions]`

This module deploys a virtual machine extension.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Compute/virtualMachines/extensions` | 2021-07-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `name` | string |  |  | Required. The name of the virtual machine extension. |
| `virtualMachineName` | string |  |  | Required. The name of the virtual machine that extension is provisioned for. |
| `location` | string | `resourceGroup().location` |  | Optional. The location the extension is deployed to. |
| `type` | string |  |  | Required. Specifies the type of the extension; an example is "CustomScriptExtension". |
| `typeHandlerVersion` | string |  |  | Required. Specifies the version of the script handler. |
| `autoUpgradeMinorVersion` | bool |  |  | Required. Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. |
| `forceUpdateTag` | string | '' |  | Optional. How the extension handler should be forced to update even if the extension configuration has not changed. |
| `settings` | object | {} |  | Optional. Any object that contains the extension specific settings |
| `protectedSettings` | secureObject | {} |  | Optional. Any object that contains the extension specific protected settings |
| `supressFailures` | bool | `false` |  | Optional. Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false. |
| `enableAutomaticUpgrade` | bool |  |  | Required. Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. |
| `cuaId` | string | '' |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `extensionName` | string | The Name of the extension. |
| `extensionResourceGroup` | string | The name of the Resource Group the secret was extension in. |
| `extensionId` | string | The Resource ID of the extension. |

## Template references

- [Azure Virtual Machine Extensions Overview](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/overview)
- [Azure Virtual Machine Extensions Template](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines/extensions?tabs=bicep)

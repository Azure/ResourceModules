# Virtual Machine Extensions `[Microsoft.Compute/virtualMachines/extensions]`

This module deploys a virtual machine extension.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Compute/virtualMachines/extensions` | 2021-07-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoUpgradeMinorVersion` | bool |  |  | Required. Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `enableAutomaticUpgrade` | bool |  |  | Required. Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available |
| `forceUpdateTag` | string |  |  | Optional. How the extension handler should be forced to update even if the extension configuration has not changed |
| `location` | string | `[resourceGroup().location]` |  | Optional. The location the extension is deployed to |
| `name` | string |  |  | Required. The name of the virtual machine extension |
| `protectedSettings` | secureObject | `{object}` |  | Optional. Any object that contains the extension specific protected settings |
| `publisher` | string |  |  | Required. The name of the extension handler publisher |
| `settings` | object | `{object}` |  | Optional. Any object that contains the extension specific settings |
| `supressFailures` | bool |  |  | Optional. Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false |
| `type` | string |  |  | Required. Specifies the type of the extension; an example is "CustomScriptExtension" |
| `typeHandlerVersion` | string |  |  | Required. Specifies the version of the script handler |
| `virtualMachineName` | string |  |  | Required. The name of the virtual machine that extension is provisioned for |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `extensionName` | string | The name of the extension |
| `extensionResourceGroup` | string | The name of the Resource Group the extension was created in. |
| `extensionResourceId` | string | The resource ID of the extension |

## Template references

- [Virtualmachines/Extensions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-07-01/virtualMachines/extensions)

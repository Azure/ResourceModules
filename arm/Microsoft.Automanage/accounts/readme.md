# AutoManage `[Microsoft.Automanage/accounts]`

This module deploys an AutoManage account and associates VM with it.

## Resource Types
| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Automanage/accounts` | 2020-06-30-preview |
| `Microsoft.Compute/virtualMachines/providers/configurationProfileAssignments` | 2020-06-30-preview |

## Parameters
| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoManageAccountName` | string | `[format('{0}-AutoManage', replace(subscription().displayName, ' ', ''))]` |  | Optional. The name of automanage account |
| `autoManageAccountResourceGroupName` | string | `[format('{0}_group', replace(subscription().displayName, ' ', ''))]` |  | Optional. The resource group name where automanage will be created |
| `configurationProfile` | string | `Production` | `[Production, Dev/Test]` | Optional. The configuration profile of automanage |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered. |
| `location` | string | `[deployment().location]` |  | Optional. The location of automanage |
| `vmName` | string |  |  | Required. The name of the VM to be associated |
| `vmResourceGroupName` | string |  |  | Required. The name of the VM resource group |

## Outputs
| Output Name | Type |
| :-- | :-- |
| `autoManageAccountName` | string |
| `autoManageAccountResourceGroup` | string |
| `autoManageAccountResourceId` | string |

## Template references
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Accounts](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2020-06-30-preview/accounts)

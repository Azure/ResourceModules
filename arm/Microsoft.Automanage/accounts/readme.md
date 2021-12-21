# Automanage Accounts `[Microsoft.Automanage/accounts]`

This module deploys an Automanage account and associates VM with it.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Automanage/accounts` | 2020-06-30-preview |
| `Microsoft.Compute/virtualMachines/providers/configurationProfileAssignments` | 2021-04-30-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. |
| `location` | string | `[resourceGroup().location]` |  | Optional. The location of automanage |
| `name` | string | `[format('{0}-AutoManage', replace(subscription().displayName, ' ', ''))]` |  | Optional. The name of automanage account |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `autoManageAccountName` | string | The name of the auto manage account |
| `autoManageAccountResourceGroup` | string | The resource group the auto manage account was deployed into |
| `autoManageAccountResourceId` | string | The resource ID of the auto manage account |
| `principalId` | string | The principal ID of the system assigned identity |

## Template references

- [Define resources with Bicep and ARM templates](https://docs.microsoft.com/en-us/azure/templates)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)

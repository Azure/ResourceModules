# Batch BatchAccounts Applications `[Microsoft.Batch/batchAccounts/applications]`

This module deploys Batch BatchAccounts Applications.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Batch/batchAccounts/applications` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Batch/2022-01-01/batchAccounts/applications) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `appName` | string | Name of the application package. |
| `batchName` | string |  |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `allowUpdates` | bool | `True` | A value indicating whether packages within the application may be overwritten using the same version string. |
| `defaultVersion` | string | `''` | The package to use if a client requests the application but does not specify a version. This property can only be set to the name of an existing package.	 |
| `displayName` | string | `''` | The display name for the application package. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the created application. |
| `resourceGroupName` | string | The name of the resource group the application was created in. |
| `resourceId` | string | The resource ID of the created application. |

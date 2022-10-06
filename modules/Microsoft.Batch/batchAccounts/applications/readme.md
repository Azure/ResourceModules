# Batch BatchAccounts Applications `[Microsoft.Batch/batchAccounts/applications]`

This module deploys Batch BatchAccounts Applications.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Batch/batchAccounts/applications` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Batch/2022-01-01/batchAccounts/applications) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `appName` | string | Name of the application package. |
| `batchName` | string | Name of the batch Account. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `allowUpdates` | bool | `True` | A value indicating whether packages within the application may be overwritten using the same version string. |
| `displayName` | string | `''` | The display name for the application package. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the created application. |
| `resourceGroupName` | string | The name of the resource group the application was created in. |
| `resourceId` | string | The resource ID of the created application. |

## Cross-referenced modules

_None_

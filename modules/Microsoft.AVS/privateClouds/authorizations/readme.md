# AVS PrivateClouds Authorizations `[Microsoft.AVS/privateClouds/authorizations]`

This module deploys AVS PrivateClouds Authorizations.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AVS/privateClouds/authorizations` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.AVS/privateClouds/authorizations) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the ExpressRoute Circuit Authorization in the private cloud |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateCloudName` | string | The name of the parent privateClouds. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization. |
| `resourceGroupName` | string | The name of the resource group the authorization was created in. |
| `resourceId` | string | The resource ID of the authorization. |

## Cross-referenced modules

_None_

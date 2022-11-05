# AVS PrivateClouds HcxEnterpriseSites `[Microsoft.AVS/privateClouds/hcxEnterpriseSites]`

This module deploys AVS PrivateClouds HcxEnterpriseSites.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AVS/privateClouds/hcxEnterpriseSites` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.AVS/privateClouds/hcxEnterpriseSites) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the HCX Enterprise Site in the private cloud |

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
| `name` | string | The name of the hcxEnterpriseSite. |
| `resourceGroupName` | string | The name of the resource group the hcxEnterpriseSite was created in. |
| `resourceId` | string | The resource ID of the hcxEnterpriseSite. |

## Cross-referenced modules

_None_

# Web StaticSites LinkedBackends `[Microsoft.Web/staticSites/linkedBackends]`

This module deploys Web StaticSites LinkedBackends.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/staticSites/linkedBackends` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/staticSites) |

## Parameters

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `staticSiteName` | string | The name of the parent Static Web App. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `linkedBackendName` | string | `[uniqueString(parameters('backendResourceId'))]` | Name of the backend to link to the static site. |
| `region` | string | `[resourceGroup().location]` | The region of the backend linked to the static site. |

**Requried parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `backendResourceId` | string | The resource id of the backend linked to the static site. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the static site. |
| `resourceGroupName` | string | The resource group the static site was deployed into. |
| `resourceId` | string | The resource ID of the static site. |

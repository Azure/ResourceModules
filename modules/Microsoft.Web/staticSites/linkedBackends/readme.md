# Static Site Linked Backend `[Microsoft.Web/staticSites/linkedBackends]`

This module deploys a Custom Function App into a Static Site using the linkedBackends property.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/staticSites/linkedBackends` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/staticSites/linkedBackends) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `backendResourceId` | string | The resource id of the backend linked to the static site. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `staticSiteName` | string | The name of the parent Static Web App. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `name` | string | `[uniqueString(parameters('backendResourceId'))]` | Name of the backend to link to the static site. |
| `region` | string | `[resourceGroup().location]` | The region of the backend linked to the static site. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the static site. |
| `resourceGroupName` | string | The resource group the static site was deployed into. |
| `resourceId` | string | The resource ID of the static site. |

## Cross-referenced modules

_None_

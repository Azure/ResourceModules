# Search Services Private Link Resources `[Microsoft.Search/searchServices/sharedPrivateLinkResources]`

This module deploys a Search Service Private Link Resource.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2022-09-01/searchServices/sharedPrivateLinkResources) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `groupId` | string | The group ID from the provider of resource the shared private link resource is for. |
| `name` | string | The name of the shared private link resource managed by the Azure Cognitive Search service within the specified resource group. |
| `privateLinkResourceId` | string | The resource ID of the resource the shared private link resource is for. |
| `requestMessage` | string | The request message for requesting approval of the shared private link resource. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `searchServiceName` | string | The name of the parent searchServices. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `resourceRegion` | string | `''` | Can be used to specify the Azure Resource Manager location of the resource to which a shared private link is to be created. This is only required for those resources whose DNS configuration are regional (such as Azure Kubernetes Service). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the shared private link resource. |
| `resourceGroupName` | string | The name of the resource group the shared private link resource was created in. |
| `resourceId` | string | The resource ID of the shared private link resource. |

## Cross-referenced modules

_None_

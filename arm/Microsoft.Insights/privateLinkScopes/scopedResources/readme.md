# Insights PrivateLinkScopes ScopedResources `[Microsoft.Insights/privateLinkScopes/scopedResources]`

This module deploys Insights PrivateLinkScopes ScopedResources.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Insights/privateLinkScopes/scopedResources` | 2021-07-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `linkedResourceId` | string |  |  | Required. The resource ID of the scoped Azure monitor resource. |
| `name` | string |  |  | Required. Name of the private link scoped resource. |
| `privateLinkScopeName` | string |  |  | Required. Name of the parent private link scope. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `scopedResourceName` | string | The full name of the deployed Scoped Resource |
| `scopedResourceResourceGroup` | string | The name of the resource group where the resource has been deployed |
| `scopedResourceResourceId` | string | The resource ID of the deployed scopedResource |

## Template references

- [Privatelinkscopes/Scopedresources](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-07-01-preview/privateLinkScopes/scopedResources)

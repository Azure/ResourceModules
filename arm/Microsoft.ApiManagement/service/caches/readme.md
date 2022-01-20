# API Management Service Cache `[Microsoft.ApiManagement/service/caches]`

This module deploys an API Management Service Cache.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/caches` | 2021-08-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `cacheDescription` | string |  |  | Optional. Cache description |
| `connectionString` | string |  |  | Required. Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}} |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier). |
| `resourceId` | string |  |  | Optional. Original uri of entity in external system cache points to. |
| `useFromLocation` | string |  |  | Required. Location identifier to use cache from (should be either 'default' or valid Azure region identifier) |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service cache |
| `resourceGroupName` | string | The resource group the API management service cache was deployed into |
| `resourceId` | string | The resource ID of the API management service cache |

## Template references

- [Service/Caches](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/caches)

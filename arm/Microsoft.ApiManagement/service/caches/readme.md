# API Management Service Cache `[Microsoft.ApiManagement/service/caches]`

This module deploys an API Management Service Cache.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/caches` | 2021-08-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `apiManagementServiceName` | string | The name of the of the API Management service. |
| `connectionString` | string | Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}} |
| `name` | string | Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier). |
| `useFromLocation` | string | Location identifier to use cache from (should be either 'default' or valid Azure region identifier) |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `cacheDescription` | string | `''` | Cache description |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `resourceId` | string | `''` | Original uri of entity in external system cache points to. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service cache |
| `resourceGroupName` | string | The resource group the API management service cache was deployed into |
| `resourceId` | string | The resource ID of the API management service cache |

## Template references

- [Service/Caches](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/caches)

# CDN Profiles Endpoints Origins `[Microsoft.Cdn/profiles/endpoints/origins]`

This module deploys a CDN Profile Endpoint Origin.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/endpoints/origins` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints/origins) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `endpointName` | string | The name of the CDN Endpoint. |
| `hostName` | string | The hostname of the origin. |
| `name` | string | The name of the origin. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `priority` | int | `-1` | The priority of origin in given origin group for load balancing. Required if `weight` is provided. |
| `privateLinkAlias` | string |  | The private link alias of the origin. Required if privateLinkLocation is provided. |
| `privateLinkLocation` | string |  | The private link location of the origin. Required if privateLinkAlias is provided. |
| `weight` | int | `-1` | The weight of the origin used for load balancing. Required if `priority` is provided.. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enabled` | bool | `True` | Whether the origin is enabled for load balancing. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `httpPort` | int | `80` | The HTTP port of the origin. |
| `httpsPort` | int | `443` | The HTTPS port of the origin. |
| `originHostHeader` | string |  | The host header value sent to the origin. |
| `privateLinkResourceId` | string |  | The private link resource ID of the origin. |
| `profileName` | string | `'default'` | The name of the CDN profile. Default to "default". |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the endpoint. |
| `resourceGroupName` | string | The name of the resource group the endpoint was created in. |
| `resourceId` | string | The resource ID of the endpoint. |

## Cross-referenced modules

_None_

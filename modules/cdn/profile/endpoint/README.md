# CDN Profiles Endpoints `[Microsoft.Cdn/profiles/endpoints]`

This module deploys a CDN Profile Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/endpoints` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints) |
| `Microsoft.Cdn/profiles/endpoints/origins` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints/origins) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the endpoint under the profile which is unique globally. |
| `properties` | object | Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details). |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `profileName` | string | The name of the parent CDN profile. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Resource location. |
| `tags` | object | `{object}` | Endpoint tags. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `endpointProperties` | object | The properties of the endpoint. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the endpoint. |
| `resourceGroupName` | string | The name of the resource group the endpoint was created in. |
| `resourceId` | string | The resource ID of the endpoint. |

## Cross-referenced modules

_None_

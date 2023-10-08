# CDN Profiles Origin `[Microsoft.Cdn/profiles/originGroups/origins]`

This module deploys a CDN Profile Origin.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/originGroups/origins` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/profiles/originGroups/origins) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `hostName` | string | The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint. |
| `name` | string | The name of the origion. |
| `originGroupName` | string | The name of the group. |
| `profileName` | string | The name of the CDN profile. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enabledState` | string | `'Enabled'` | `[Disabled, Enabled]` | Whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool. |
| `enforceCertificateNameCheck` | bool | `True` |  | Whether to enable certificate name check at origin level. |
| `httpPort` | int | `80` |  | The value of the HTTP port. Must be between 1 and 65535. |
| `httpsPort` | int | `443` |  | The value of the HTTPS port. Must be between 1 and 65535. |
| `originHostHeader` | string | `''` |  | The host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint. |
| `priority` | int | `1` |  | Priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5. |
| `sharedPrivateLinkResource` | object | `{object}` |  | The properties of the private link resource for private origin. |
| `weight` | int | `1000` |  | Weight of the origin in given origin group for load balancing. Must be between 1 and 1000. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the origin. |
| `resourceGroupName` | string | The name of the resource group the origin was created in. |
| `resourceId` | string | The resource id of the origin. |

## Cross-referenced modules

_None_

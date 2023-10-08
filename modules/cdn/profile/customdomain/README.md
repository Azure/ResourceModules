# CDN Profiles Custom Domains `[Microsoft.Cdn/profiles/customDomains]`

This module deploys a CDN Profile Custom Domains.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/customDomains` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/profiles/customDomains) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `certificateType` | string | `[CustomerCertificate, ManagedCertificate]` | The type of the certificate used for secure delivery. |
| `hostName` | string |  | The host name of the domain. Must be a domain name. |
| `name` | string |  | The name of the custom domain. |
| `profileName` | string |  | The name of the CDN profile. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `extendedProperties` | object | `{object}` |  | Key-Value pair representing migration properties for domains. |
| `minimumTlsVersion` | string | `'TLS12'` | `[TLS10, TLS12]` | The minimum TLS version required for the custom domain. Default value: TLS12. |
| `preValidatedCustomDomainResourceId` | string | `''` |  | Resource reference to the Azure resource where custom domain ownership was prevalidated. |
| `secretName` | string | `''` |  | The name of the secret. ie. subs/rg/profile/secret. |

**Optonal parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `azureDnsZoneResourceId` | string | `''` | Resource reference to the Azure DNS zone. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the custom domain. |
| `resourceGroupName` | string | The name of the resource group the custom domain was created in. |
| `resourceId` | string | The resource id of the custom domain. |

## Cross-referenced modules

_None_

# CDN Profiles Secret `[Microsoft.Cdn/profiles/secrets]`

This module deploys a CDN Profile Secret.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/secrets` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/profiles/secrets) |

## Parameters

**Required parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `name` | string |  |  | The name of the secrect. |
| `type` | string | `'AzureFirstPartyManagedCertificate'` | `[AzureFirstPartyManagedCertificate, CustomerCertificate, ManagedCertificate, UrlSigningKey]` | The type of the secrect. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `profileName` | string |  | The name of the parent CDN profile. Required if the template is used in a standalone deployment. |
| `secretSourceResourceId` | string | `''` | The resource ID of the secrect source. Required if the type is CustomerCertificate. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `secretVersion` | string | `''` | The version of the secret. |
| `subjectAlternativeNames` | array | `[]` | The subject alternative names of the secrect. |
| `useLatestVersion` | bool | `False` | Indicates whether to use the latest version of the secrect. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the secrect. |
| `resourceGroupName` | string | The name of the resource group the secret was created in. |
| `resourceId` | string | The resource ID of the secrect. |

## Cross-referenced modules

_None_

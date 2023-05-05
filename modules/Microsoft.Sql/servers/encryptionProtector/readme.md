# Sql Servers EncryptionProtector `[Microsoft.Sql/servers/encryptionProtector]`

This module deploys an Sql Servers Encryption Protector.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/encryptionProtector` | [2022-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/encryptionProtector) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `serverKeyName` | string | The name of the server key. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `sqlServerName` | string | The name of the sql server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoRotationEnabled` | bool | `False` |  | Key auto rotation opt-in. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `serverKeyType` | string | `'ServiceManaged'` | `[AzureKeyVault, ServiceManaged]` | The encryption protector type. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed encryption protector. |
| `resourceGroupName` | string | The resource group of the deployed encryption protector. |
| `resourceId` | string | The resource ID of the encryption protector. |

## Cross-referenced modules

_None_

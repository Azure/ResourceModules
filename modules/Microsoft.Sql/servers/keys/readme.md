# SQL Servers Keys `[Microsoft.Sql/servers/keys]`

This module deploys a key for a SQL server.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/keys` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/keys) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `serverName` | string | The name of the parent SQL server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `serverKeyType` | string | `'ServiceManaged'` | `[AzureKeyVault, ServiceManaged]` | The encryption protector type like "ServiceManaged", "AzureKeyVault". |
| `uri` | string | `''` |  | The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed server key. |
| `resourceGroupName` | string | The resource group of the deployed server key. |
| `resourceId` | string | The resource ID of the deployed server key. |

## Cross-referenced modules

_None_

# SQL Managed Instance Keys `[Microsoft.Sql/managedInstances/keys]`

This module deploys a key for a SQL managed instance.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/keys` | 2021-05-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `managedInstanceName` | string | Name of the SQL managed instance. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `''` |  | The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern |
| `serverKeyType` | string | `'ServiceManaged'` | `[AzureKeyVault, ServiceManaged]` | The encryption protector type like "ServiceManaged", "AzureKeyVault" |
| `uri` | string | `''` |  | The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed managed instance |
| `resourceGroupName` | string | The resource group of the deployed managed instance |
| `resourceId` | string | The resource ID of the deployed managed instance |

## Template references

- [Managedinstances/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/keys)

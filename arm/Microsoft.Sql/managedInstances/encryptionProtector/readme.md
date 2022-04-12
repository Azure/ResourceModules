# SQL Managed Instance Encryption Protector `[Microsoft.Sql/managedInstances/encryptionProtector]`

This module deploys an encryption protector for a SQL managed instance.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/encryptionProtector` | 2021-05-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `managedInstanceName` | string |  | Name of the SQL managed instance. |
| `name` | string | `'current'` | The name of the encryptionProtector |
| `serverKeyName` | string |  | The name of the SQL managed instance key. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoRotationEnabled` | bool | `False` |  | Key auto rotation opt-in flag |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `serverKeyType` | string | `'ServiceManaged'` | `[AzureKeyVault, ServiceManaged]` | The encryption protector type like "ServiceManaged", "AzureKeyVault". |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed managed instance |
| `resourceGroupName` | string | The resource group of the deployed managed instance |
| `resourceId` | string | The resource ID of the deployed managed instance |

## Template references

- [Managedinstances/Encryptionprotector](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/encryptionProtector)

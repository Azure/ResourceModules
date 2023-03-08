# SQL Managed Instance Encryption Protector `[Microsoft.Sql/managedInstances/encryptionProtector]`

This module deploys an encryption protector for a SQL managed instance.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/encryptionProtector` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/managedInstances/encryptionProtector) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `serverKeyName` | string | The name of the SQL managed instance key. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `managedInstanceName` | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoRotationEnabled` | bool | `False` |  | Key auto rotation opt-in flag. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `serverKeyType` | string | `'ServiceManaged'` | `[AzureKeyVault, ServiceManaged]` | The encryption protector type like "ServiceManaged", "AzureKeyVault". |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed managed instance encryption protector. |
| `resourceGroupName` | string | The resource group of the deployed managed instance encryption protector. |
| `resourceId` | string | The resource ID of the deployed managed instance encryption protector. |

## Cross-referenced modules

_None_

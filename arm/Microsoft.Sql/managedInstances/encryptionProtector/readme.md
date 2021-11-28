# SQL Managed Instance Encryption Protector `[Microsoft.Sql/managedInstances/encryptionProtector]`

This module deploys an encryption protector for a SQL managed instance.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/encryptionProtector` | 2021-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoRotationEnabled` | bool |  |  | Optional. Key auto rotation opt-in flag |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `managedInstanceName` | string |  |  | Required. Name of the SQL managed instance. |
| `name` | string | `current` |  | Required. The name of the encryptionProtector |
| `serverKeyName` | string |  |  | Required. The name of the SQL managed instance key. |
| `serverKeyType` | string | `ServiceManaged` | `[AzureKeyVault, ServiceManaged]` | Optional. The encryption protector type like "ServiceManaged", "AzureKeyVault". |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `encryptionProtectorName` | string | The name of the deployed managed instance |
| `encryptionProtectorResourceGroup` | string | The resource group of the deployed managed instance |
| `encryptionProtectorResourceId` | string | The resource ID of the deployed managed instance |

## Template references

- [Managedinstances/Encryptionprotector](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/encryptionProtector)

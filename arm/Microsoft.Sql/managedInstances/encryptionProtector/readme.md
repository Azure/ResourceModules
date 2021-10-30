# SqlManagedinstancesEncryptionprotector `[Microsoft.Sql/managedInstances/encryptionProtector]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/encryptionProtector` | 2021-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `autoRotationEnabled` | bool |  |  | Key auto rotation opt-in flag |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `managedInstanceName` | string |  |  | Name of the resource. |
| `name` | string | `current` |  | The name of the encryptionProtector |
| `serverKeyName` | string |  |  | The name of the managed instance key. |
| `serverKeyType` | string | `AzureKeyVault` | `[AzureKeyVault, ServiceManaged]` | The encryption protector type like "ServiceManaged", "AzureKeyVault". |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `encryptionProtectorName` | string | The name of the deployed managed instance |
| `encryptionProtectorResourceGroup` | string | The resource group of the deployed managed instance |
| `encryptionProtectorResourceId` | string | The resourceId of the deployed managed instance |

## Template references

- [Managedinstances/Encryptionprotector](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/encryptionProtector)

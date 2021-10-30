# SqlManagedinstancesKeys `[Microsoft.Sql/managedInstances/keys]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/keys` | 2017-10-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `managedInstanceName` | string |  |  | Name of the resource. |
| `name` | string |  |  | The name of the key |
| `serverKeyType` | string | `ServiceManaged` | `[AzureKeyVault, ServiceManaged]` | The encryption protector type like "ServiceManaged", "AzureKeyVault" |
| `uri` | string |  |  | The URI of the key. If the ServerKeyType is AzureKeyVault, then the URI is required. |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `keyName` | string | The name of the deployed managed instance |
| `keyResourceGroup` | string | The resource group of the deployed managed instance |
| `keyResourceId` | string | The resourceId of the deployed managed instance |

## Template references

- [Managedinstances/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-10-01-preview/managedInstances/keys)

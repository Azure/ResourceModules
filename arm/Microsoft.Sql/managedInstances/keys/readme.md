# SQL Managed Instance Keys `[Microsoft.Sql/managedInstances/keys]`

This module deploys a key for a SQL managed instance.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/keys` | 2021-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `managedInstanceName` | string |  |  | Required. Name of the SQL managed instance. |
| `name` | string |  |  | Optional. The name of the key |
| `serverKeyType` | string | `ServiceManaged` | `[AzureKeyVault, ServiceManaged]` | Optional. The encryption protector type like "ServiceManaged", "AzureKeyVault" |
| `uri` | string |  |  | Optional. The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `keyName` | string | The name of the deployed managed instance |
| `keyResourceGroup` | string | The resource group of the deployed managed instance |
| `keyResourceId` | string | The resourceId of the deployed managed instance |

## Template references

- [Managedinstances/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/keys)

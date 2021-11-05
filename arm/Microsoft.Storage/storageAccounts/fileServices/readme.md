# Storage Account file share services  `[Microsoft.Storage/storageAccounts/fileServices]`

This module can be used to deploy a file share service into a storage account.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Storage/storageAccounts/fileServices` | 2021-04-01 |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `protocolSettings` | object | `{object}` |  | Protocol settings for file service |
| `shareDeleteRetentionPolicy` | object | `{object}` |  | The service properties for soft delete. |
| `shares` | _[shares](shares/readme.md)_ array | `[]` |  | Optional. File shares to create. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `fileServiceName` | string | The name of the deployed file share service |
| `fileServiceResourceGroup` | string | The resource group of the deployed file share service |
| `fileServiceResourceId` | string | The id of the deployed file share service |

## Template references

- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Storageaccounts/Fileservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-04-01/storageAccounts/fileServices)
- [Storageaccounts/Fileservices/Shares](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/fileServices/shares)

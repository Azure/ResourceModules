# Storage Account Table `[Microsoft.Storage/storageAccounts/tableServices/tables]`

This module deploys a storage account table

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. Name of the table. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |
| `tableServicesName` | string | `default` |  | Optional. The name of the table service |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `tableName` | string | The name of the deployed file share service |
| `tableResourceGroup` | string | The resource group of the deployed file share service |
| `tableResourceId` | string | The resource ID of the deployed file share service |

## Template references

- [Storageaccounts/Tableservices/Tables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-06-01/storageAccounts/tableServices/tables)

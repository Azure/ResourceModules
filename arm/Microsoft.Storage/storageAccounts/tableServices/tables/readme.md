# Storage Account Table `[Microsoft.Storage/storageAccounts/tableServices/tables]`

This module deploys a storage account table

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `name` | string |  |  | Required. Name of the table. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `tableServiceName` | string | The name of the deployed file share service |
| `tableServiceResourceGroup` | string | The resource group of the deployed file share service |
| `tableServiceResourceId` | string | The id of the deployed file share service |

## Template references

- [Storageaccounts/Tableservices/Tables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/tableServices/tables)

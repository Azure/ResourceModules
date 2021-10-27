# Storage Account Table Services `[Microsoft.Storage/storageAccounts/tableServices]`

This module deploys a storage account table service

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/tableServices` | 2021-04-01 |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cors` | object | `{}` |  | Sets the CORS rules. You can include up to five CorsRule elements in the request. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |
| `tables` |  _[tables](.tables/readme.md)_ array | `[]` |  | Optional. The to create. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `tableServiceName` | string | The name of the deployed table service |
| `tableServiceResourceGroup` | string | The resource group of the deployed table service |
| `tableServiceResourceId` | string | The id of the deployed table service |

## Template references

- [Storageaccounts/Tableservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-04-01/storageAccounts/tableServices)
- [Storageaccounts/Tableservices/Tables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/tableServices/tables)

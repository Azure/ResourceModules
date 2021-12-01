# Storage Account Table Services `[Microsoft.Storage/storageAccounts/tableServices]`

This module deploys a storage account table service

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/tableServices` | 2021-04-01 |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string | `default` |  | Optional. The name of the table service |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |
| `tables` | _[tables](tables/readme.md)_ array | `[]` |  | Optional. tables to create. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `tableServicesName` | string | The name of the deployed table service |
| `tableServicesResourceGroup` | string | The resource group of the deployed table service |
| `tableServicesResourceId` | string | The resource ID of the deployed table service |

## Template references

- [Storageaccounts/Tableservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-04-01/storageAccounts/tableServices)
- [Storageaccounts/Tableservices/Tables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-06-01/storageAccounts/tableServices/tables)

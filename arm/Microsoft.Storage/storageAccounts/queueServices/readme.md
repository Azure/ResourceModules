# Storage Account Queue Services `[Microsoft.Storage/storageAccounts/queueServices]`

This module can be used to deploy a file share service into a storage account.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/queueServices` | 2021-04-01 |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/queueServices/queues/providers/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `queues` | _[queues](queues/readme.md)_ array | `[]` |  | Optional. Queues to create. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `queueServiceName` | string | The name of the deployed file share service |
| `queueServiceResourceGroup` | string | The resource group of the deployed file share service |
| `queueServiceResourceId` | string | The id of the deployed file share service |

## Template references

- [Storageaccounts/Queueservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-04-01/storageAccounts/queueServices)
- [Storageaccounts/Queueservices/Queues](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/queueServices/queues)

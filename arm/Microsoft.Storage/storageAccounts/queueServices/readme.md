# Storage Account Queue Services `[Microsoft.Storage/storageAccounts/queueServices]`

This module can be used to deploy a file share service into a storage account.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Storage/storageAccounts/queueServices` | 2021-04-01 |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string | `default` |  | Optional. The name of the queue service |
| `queues` | _[queues](queues/readme.md)_ array | `[]` |  | Optional. Queues to create. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `queueServicesName` | string | The name of the deployed file share service |
| `queueServicesResourceGroup` | string | The resource group of the deployed file share service |
| `queueServicesResourceId` | string | The resource ID of the deployed file share service |

## Template references

- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Storageaccounts/Queueservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-04-01/storageAccounts/queueServices)
- [Storageaccounts/Queueservices/Queues](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/queueServices/queues)

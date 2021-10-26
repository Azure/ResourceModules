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
| `cors` | object | `{object}` |  | Sets the CORS rules. You can include up to five CorsRule elements in the request. |
| `queues` | array | `[]` |  | Optional. Queues to create. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

### Parameter Usage: `queues`

The `queues` parameter accepts a JSON Array of object with "name" and "metadata" properties in each to specify the name of the queue to create and its metadata, as a name-value pair. Also RBAC can be assigned at queue level.

Here's an example of specifying a single qeue named "queue1" with no metadata and Reader role assigned to two principal Ids.

```json
"queues": {
    "value": [
        {
            "name": "queue1",
            "metadata": {},
            "roleAssignments": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "12345678-1234-1234-1234-123456789012", // object 1
                        "78945612-1234-1234-1234-123456789012" // object 2
                    ]
                }
            ]
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `queueServiceName` | string | The name of the deployed file share service |
| `queueServiceResourceGroup` | string | The resource group of the deployed file share service |
| `queueServiceResourceId` | string | The id of the deployed file share service |

## Template references

- [Storageaccounts/Queueservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-04-01/storageAccounts/queueServices)
- [Storageaccounts/Queueservices/Queues](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/queueServices/queues)

# Storage Account file share services  `[Microsoft.Storage/storageAccounts/fileServices]`

This module can be used to deploy a file share service into a storage account.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/fileServices` | 2021-06-01 |
| `Microsoft.Storage/storageAccounts/fileServices/fileshares/providers/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cors` | object | `{object}` |  | Sets the CORS rules. You can include up to five CorsRule elements in the request. |
| `fileShares` | array | `[]` |  | Optional. File shares to create. |
| `protocolSettings` | object | `{object}` |  | Protocol settings for file service |
| `shareDeleteRetentionPolicy` | object | `{object}` |  | The service properties for soft delete. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

### Parameter Usage: `fileShares`

The `fileShares` parameter accepts a JSON Array of object with "name" and "shareQuota" properties in each to specify the name of the File Shares to create and the maximum size of the shares, in gigabytes. Also RBAC can be assigned at File Share level.

Here's an example of specifying a single File Share named "avdprofiles" with 5TB (5120GB) of shareQuota and Reader role assigned to two principal Ids.

```json
"fileShares": {
    "value": [
        {
            "name": "avdprofiles",
            "shareQuota": "5120",
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
| `fileServiceName` | string | The name of the deployed file share service |
| `fileServiceResourceGroup` | string | The resource group of the deployed file share service |
| `fileServiceResourceId` | string | The id of the deployed file share service |

## Template references

- [Storageaccounts/Fileservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-06-01/storageAccounts/fileServices)
- [Storageaccounts/Fileservices/Shares](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/fileServices/shares)

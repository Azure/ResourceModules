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
| `fileShares` | _[shares](.shares/readme.md)_ array | `[]` |  | Optional. File shares to create. |
| `protocolSettings` | object | `{object}` |  | Protocol settings for file service |
| `shareDeleteRetentionPolicy` | object | `{object}` |  | The service properties for soft delete. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

### Parameter Usage: `cors`

| Parameter Name | Type | Possible Values | Description |
| :-- | :-- | :-- | :-- |
| `allowedHeaders` | array | | A list of headers allowed to be part of the cross-origin request. |
| `allowedMethods` | array | `['DELETE', 'GET', 'HEAD', 'MERGE', 'OPTIONS', 'POST', 'PUT']` | A list of HTTP methods that are allowed to be executed by the origin. |
| `allowedOrigins` | array | A list of origin domains that will be allowed via CORS, or "*" to allow all domains |
| `exposedHeaders` | array | A list of response headers to expose to CORS clients. |
| `maxAgeInSeconds` | int  | The number of seconds that the client/browser should cache a preflight response. |

```json
"cors": {
    "corsRules": [
        {
            "allowedHeaders": [ "x-ms-meta-data*","x-ms-meta-target*","x-ms-meta-abc" ],
            "allowedMethods": [ "PUT","GET" ],
            "allowedOrigins": [ "http://www.contoso.com", "http://www.fabrikam.com" ],
            "exposedHeaders": [ "x-ms-meta-*" ],
            "maxAgeInSeconds": 200
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

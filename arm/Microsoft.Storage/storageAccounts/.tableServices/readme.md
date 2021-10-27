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
| `tableServiceName` | string | The name of the deployed table service |
| `tableServiceResourceGroup` | string | The resource group of the deployed table service |
| `tableServiceResourceId` | string | The id of the deployed table service |

## Template references

- [Storageaccounts/Tableservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-04-01/storageAccounts/tableServices)
- [Storageaccounts/Tableservices/Tables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/tableServices/tables)

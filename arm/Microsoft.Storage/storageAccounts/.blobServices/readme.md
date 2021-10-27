# Storage Account blob services `[Microsoft.Storage/storageAccounts/blobServices]`

This module can be used to deploy a blob service into a storage account.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/blobServices` | 2021-08-01 |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/blobServices/containers/providers/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `automaticSnapshotPolicyEnabled` | bool |  |  | Optional. Automatic Snapshot is enabled if set to true. |
| `blobContainers` | _[containers](.containers/readme.md)_ array | `[]` |  | Optional. Blob containers to create. |
| `deleteRetentionPolicy` | bool | `True` |  | Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service. |
| `cors` | object | `{object}` | | Sets the CORS rules. You can include up to five CorsRule elements in the request. |
| `deleteRetentionPolicyDays` | int | `7` |  | Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365. |
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
| `blobServiceName` | string | The name of the deployed blob service |
| `blobServiceResourceGroup` | string | The name of the deployed blob service |
| `blobServiceResourceId` | string | The id of the deployed blob service |

## Template references

- [Storageaccounts/Blobservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-08-01/storageAccounts/blobServices)
- [Storageaccounts/Blobservices/Containers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices/containers)
- [Storageaccounts/Blobservices/Containers/Immutabilitypolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices/containers/immutabilityPolicies)

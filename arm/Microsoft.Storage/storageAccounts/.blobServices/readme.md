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
| `blobContainers` | array | `[]` |  | Optional. Blob containers to create. |
| `deleteRetentionPolicy` | bool | `True` |  | Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service. |
| `deleteRetentionPolicyDays` | int | `7` |  | Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

### Parameter Usage: `blobContainers`

The `blobContainer` parameter accepts a JSON Array of object with "name" and "publicAccess" properties in each to specify the name of the Blob Containers to create and level of public access (container level, blob level or none). Also RBAC can be assigned at Blob Container level

Here's an example of specifying two Blob Containes. The first named "one" with public access set at container level and RBAC Reader role assigned to two principal Ids. The second named "two" with no public access level and no RBAC role assigned.

```json
"blobContainers": {
    "value": [
        {
            "name": "one",
            "publicAccess": "Container", //Container, Blob, None
            "roleAssignments": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "12345678-1234-1234-1234-123456789012", // object 1
                        "78945612-1234-1234-1234-123456789012" // object 2
                    ]
                },
        {
            "name": "two",
            "publicAccess": "None", //Container, Blob, None
            "roleAssignments": [],
            "enableWORM": true,
            "WORMRetention": 200,
            "allowProtectedAppendWrites": false
        }
    ]
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

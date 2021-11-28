# Storage Account Management Policies `[Microsoft.Storage/storageAccounts/managementPolicies]`

This module can be used to deploy a management policies into a storage account.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string | `default` |  | Optional. The name of the storage container to deploy |
| `rules` | array |  |  | Required. The Storage Account ManagementPolicies Rules |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

### Parameter Usage: `rules`

```json
[
    {
        "enabled": true,
        "name": "retention-policy",
        "type": "Lifecycle",
        "definition": {
            "actions": {
                "baseBlob": {
                    "tierToArchive": {
                        "daysAfterModificationGreaterThan": 30
                    },
                    "delete": {
                        "daysAfterModificationGreaterThan": 1096
                    }
                },
                "snapshot": {
                    "delete": {
                        "daysAfterCreationGreaterThan": 1096
                    }
                }
            },
            "filters": {
                "blobTypes": [
                    "blockBlob"
                ]
            }
        }
    }
]
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `managementPoliciesName` | string | The name of the deployed management policy |
| `managementPoliciesResourceGroup` | string | The resource group of the deployed management policy |
| `managementPoliciesResourceId` | string | The resource ID of the deployed management policy |

## Template references

- [Storageaccounts/Managementpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/managementPolicies)

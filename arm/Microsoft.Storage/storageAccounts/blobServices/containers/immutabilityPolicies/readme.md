# Blob Container Immutability Policy `[Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies]`

This module deployes an Immutability Policy for a blob container

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowProtectedAppendWrites` | bool | `True` |  | This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API |
| `containerName` | string |  |  | Required. Name of the container to apply the policy to |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `immutabilityPeriodSinceCreationInDays` | int | `365` |  | The immutability period for the blobs in the container since the policy creation, in days. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `immutabilityPolicyName` | string | The name of the deployed immutability policy. |
| `immutabilityPolicyResourceGroup` | string | The resource group of the deployed immutability policy. |
| `immutabilityPolicyResourceId` | string | The id of the deployed immutability policy. |

## Template references

- [Storageaccounts/Blobservices/Containers/Immutabilitypolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices/containers/immutabilityPolicies)

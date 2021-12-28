# Blob Container Immutability Policy `[Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies]`

This module deployes an Immutability Policy for a blob container

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowProtectedAppendWrites` | bool | `True` |  | Optional. This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API |
| `blobServicesName` | string | `default` |  | Optional. Name of the blob service. |
| `containerName` | string |  |  | Required. Name of the container to apply the policy to |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `immutabilityPeriodSinceCreationInDays` | int | `365` |  | Optional. The immutability period for the blobs in the container since the policy creation, in days. |
| `name` | string | `default` |  | Optional. Name of the immutable policy. |
| `storageAccountName` | string |  |  | Required. Name of the Storage Account. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `immutabilityPolicyName` | string | The name of the deployed immutability policy. |
| `immutabilityPolicyResourceGroup` | string | The resource group of the deployed immutability policy. |
| `immutabilityPolicyResourceId` | string | The resource ID of the deployed immutability policy. |

## Template references

- [Storageaccounts/Blobservices/Containers/Immutabilitypolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices/containers/immutabilityPolicies)

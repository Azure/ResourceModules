# Recovery Service Vault Protection Container Protected Item `[Microsoft.RecoveryServices/vaults/protectionContainers/protectedItems]`

This module deploys a Protection Container Protected Item for a Recovery Services Vault

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-06-01/vaults/backupFabrics/protectionContainers/protectedItems) |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `name` | string |  | Name of the resource. |
| `policyId` | string |  | ID of the backup policy with which this item is backed up. |
| `protectedItemType` | string | `[AzureFileShareProtectedItem, AzureVmWorkloadSAPAseDatabase, AzureVmWorkloadSAPHanaDatabase, AzureVmWorkloadSQLDatabase, DPMProtectedItem, GenericProtectedItem, MabFileFolderProtectedItem, Microsoft.ClassicCompute/virtualMachines, Microsoft.Compute/virtualMachines, Microsoft.Sql/servers/databases]` | The backup item type. |
| `sourceResourceId` | string |  | Resource ID of the resource to back up. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `protectionContainerName` | string | Name of the Azure Recovery Service Vault Protection Container. Required if the template is used in a standalone deployment. |
| `recoveryVaultName` | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The Name of the protected item. |
| `resourceGroupName` | string | The name of the Resource Group the protected item was created in. |
| `resourceId` | string | The resource ID of the protected item. |

# RecoveryServicesProtectionContainer `[Microsoft.RecoveryServices/vaults/protectionContainers]`

This module deploys a Protection Container for a Recovery Services Vault

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backupManagementType` | string |  | `[AzureBackupServer, AzureIaasVM, AzureSql, AzureStorage, AzureWorkload, DPM, DefaultBackup, Invalid, MAB, ]` | Optional. Backup management type to execute the current Protection Container job. |
| `containerType` | string |  | `[AzureBackupServerContainer, AzureSqlContainer, GenericContainer, Microsoft.ClassicCompute/virtualMachines, Microsoft.Compute/virtualMachines, SQLAGWorkLoadContainer, StorageContainer, VMAppContainer, Windows, ]` | Optional. Type of the container |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `friendlyName` | string |  |  | Optional. Friendly name of the Protection Container |
| `name` | string |  |  | Required. Name of the Azure Recovery Service Vault Protection Container |
| `recoveryVaultName` | string |  |  | Required. Name of the Azure Recovery Service Vault |
| `sourceResourceId` | string |  |  | Optional. Resource ID of the target resource for the Protection Container  |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `protectionContainerId` | string | The Resource ID of the Protection Container. |
| `protectionContainerName` | string | The Name of the Protection Container. |
| `protectionContainerResourceGroup` | string | The name of the Resource Group the Protection Container was created in. |

## Template references

- [Vaults/Backupfabrics/Protectioncontainers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-08-01/vaults/backupFabrics/protectionContainers)

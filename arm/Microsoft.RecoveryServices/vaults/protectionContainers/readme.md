# RecoveryServicesProtectionContainer `[Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers]`

This module deploys a Protection Container for a Recovery Services Vault

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `recoveryVaultName` | string | `` |  | Required. Name of the Azure Recovery Service Vault |
| `protectionContainerName` | string | `` |  | Required. Name of the Azure Recovery Service Vault Protection Container |
| `backupManagementType` | string | `Invalid` | `[AzureBackupServer,AzureIaasVM,AzureSql,AzureStorage,AzureWorkload,DPM,DefaultBackup,Invalid,MAB]` |  Optional. Backup management type to execute the current Protection Container job. |
| `sourceResourceId` | string | `` |  | Optional. Resource Id of the target resource for the Protection Container |
| `friendlyName` | string | `` |  | Optional. Friendly name of the Protection Container |
| `containerType` | string | `` | `[AzureBackupServerContainer,AzureSqlContainer,GenericContainer,Microsoft.ClassicCompute/virtualMachines,Microsoft.Compute/virtualMachines,SQLAGWorkLoadContainer,StorageContainer,VMAppContainer,Windows]` | Optional. Type of the container |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |

## Outputs

| Output Name | Type |
| :-- | :-- |
| `protectionContainerResourceGroup` | string |
| `protectionContainerId` | string |

## Template references

- [Vaults/Protectioncontainers](https://docs.microsoft.com/en-us/azure/templates/microsoft.recoveryservices/2021-08-01/vaults/backupfabrics/protectioncontainers?tabs=bicep)

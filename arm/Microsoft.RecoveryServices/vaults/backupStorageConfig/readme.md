# RecoveryServicesVaultsBackupStorageConfig `[Microsoft.RecoveryServices/vaults/backupstorageconfig]`

This module deploys the Backup Storage Configuration for the Recovery Service Vault
## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupstorageconfig` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `recoveryVaultName` | string | `` |  | Required. Name of the Azure Recovery Service Vault |
| `vaultStorageType` | string | `GeoRedundant` | `[LocallyRedundant, GeoRedundant, ReadAccessGeoZoneRedundant, ZoneRedundant]` | Optional. Change Vault Storage Type (Works if vault has not registered any backup instance) |
| `enableCRR` | bool | `True` |  | Optional. Enable CRR (Works if vault has not registered any backup instance) |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |


## Outputs

| Output Name | Type |
| :-- | :-- |
| `vaultStorageConfigResourceGroup` | string |

## Template references

- [Vaults/Backupstorageconfig](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2020-02-02/vaults/backupstorageconfig)

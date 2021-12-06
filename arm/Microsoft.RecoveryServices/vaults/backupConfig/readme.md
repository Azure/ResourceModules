# Recovery Services Vault Backup Config `[Microsoft.RecoveryServices/vaults/backupconfig]`

This module deploys recovery services vault backup config.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupconfig` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `enhancedSecurityState` | string | `Enabled` | `[Disabled, Enabled]` | Optional. Enable this setting to protect hybrid backups against accidental deletes and add additional layer of authentication for critical operations. |
| `name` | string | `vaultconfig` |  | Optional. Name of the Azure Recovery Service Vault Backup Policy |
| `recoveryVaultName` | string |  |  | Required. Name of the Azure Recovery Service Vault |
| `resourceGuardOperationRequests` | array | `[]` |  | Optional. ResourceGuard Operation Requests |
| `softDeleteFeatureState` | string | `Enabled` | `[Disabled, Enabled]` | Optional. Enable this setting to protect backup data for Azure VM, SQL Server in Azure VM and SAP HANA in Azure VM from accidental deletes |
| `storageModelType` | string | `GeoRedundant` | `[GeoRedundant, LocallyRedundant, ReadAccessGeoZoneRedundant, ZoneRedundant]` | Optional. Storage type |
| `storageType` | string | `GeoRedundant` | `[GeoRedundant, LocallyRedundant, ReadAccessGeoZoneRedundant, ZoneRedundant]` | Optional. Storage type |
| `storageTypeState` | string | `Locked` | `[Locked, Unlocked]` | Optional. Once a machine is registered against a resource, the storageTypeState is always Locked. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `backupConfigName` | string | The name of the backup config |
| `backupConfigResourceGroup` | string | The name of the resource group the backup config was created in. |
| `backupConfigResourceId` | string | The resource ID of the backup config |

## Template references

- [Vaults/Backupconfig](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-08-01/vaults/backupconfig)

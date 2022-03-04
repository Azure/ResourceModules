# RecoveryServicesVaultsBackupStorageConfig `[Microsoft.RecoveryServices/vaults/backupstorageconfig]`

This module deploys the Backup Storage Configuration for the Recovery Service Vault
## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupstorageconfig` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `crossRegionRestoreFlag` | bool | `True` |  | Optional. Opt in details of Cross Region Restore feature |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `vaultstorageconfig` |  | Optional. The name of the backup storage config |
| `recoveryVaultName` | string |  |  | Required. Name of the Azure Recovery Service Vault |
| `storageModelType` | string | `GeoRedundant` | `[GeoRedundant, LocallyRedundant, ReadAccessGeoZoneRedundant, ZoneRedundant]` | Optional. Change Vault Storage Type (Works if vault has not registered any backup instance) |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup storage config |
| `resourceGroupName` | string | The name of the Resource Group the backup storage configuration was created in. |
| `resourceId` | string | The resource ID of the backup storage config |

## Template references

- [Vaults/Backupstorageconfig](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-08-01/vaults/backupstorageconfig)

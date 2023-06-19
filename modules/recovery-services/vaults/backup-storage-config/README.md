# Recovery Services Vault Backup Storage Config `[Microsoft.RecoveryServices/vaults/backupstorageconfig]`

This module deploys a Recovery Service Vault Backup Storage Configuration.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupstorageconfig` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupstorageconfig) |

## Parameters

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `recoveryVaultName` | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `crossRegionRestoreFlag` | bool | `True` |  | Opt in details of Cross Region Restore feature. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `name` | string | `'vaultstorageconfig'` |  | The name of the backup storage config. |
| `storageModelType` | string | `'GeoRedundant'` | `[GeoRedundant, LocallyRedundant, ReadAccessGeoZoneRedundant, ZoneRedundant]` | Change Vault Storage Type (Works if vault has not registered any backup instance). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup storage config. |
| `resourceGroupName` | string | The name of the Resource Group the backup storage configuration was created in. |
| `resourceId` | string | The resource ID of the backup storage config. |

## Cross-referenced modules

_None_

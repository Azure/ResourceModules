# Recovery Services Vault Backup Config `[Microsoft.RecoveryServices/vaults/backupconfig]`

This module deploys recovery services vault backup config.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupconfig` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupconfig) |

## Parameters

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `recoveryVaultName` | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enhancedSecurityState` | string | `'Enabled'` | `[Disabled, Enabled]` | Enable this setting to protect hybrid backups against accidental deletes and add additional layer of authentication for critical operations. |
| `isSoftDeleteFeatureStateEditable` | bool | `True` |  | Is soft delete feature state editable. |
| `name` | string | `'vaultconfig'` |  | Name of the Azure Recovery Service Vault Backup Policy. |
| `resourceGuardOperationRequests` | array | `[]` |  | ResourceGuard Operation Requests. |
| `softDeleteFeatureState` | string | `'Enabled'` | `[Disabled, Enabled]` | Enable this setting to protect backup data for Azure VM, SQL Server in Azure VM and SAP HANA in Azure VM from accidental deletes. |
| `storageModelType` | string | `'GeoRedundant'` | `[GeoRedundant, LocallyRedundant, ReadAccessGeoZoneRedundant, ZoneRedundant]` | Storage type. |
| `storageType` | string | `'GeoRedundant'` | `[GeoRedundant, LocallyRedundant, ReadAccessGeoZoneRedundant, ZoneRedundant]` | Storage type. |
| `storageTypeState` | string | `'Locked'` | `[Locked, Unlocked]` | Once a machine is registered against a resource, the storageTypeState is always Locked. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup config. |
| `resourceGroupName` | string | The name of the resource group the backup config was created in. |
| `resourceId` | string | The resource ID of the backup config. |

## Cross-referenced modules

_None_

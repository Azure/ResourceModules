# Recovery Services Vault Backup Policies `[Microsoft.RecoveryServices/vaults/backupPolicies]`

This module deploys a Recovery Services Vault Backup Policy.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Azure Recovery Service Vault Backup Policy. |
| `properties` | object | Configuration of the Azure Recovery Service Vault Backup Policy. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `recoveryVaultName` | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup policy. |
| `resourceGroupName` | string | The name of the resource group the backup policy was created in. |
| `resourceId` | string | The resource ID of the backup policy. |

## Cross-referenced modules

_None_

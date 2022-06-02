# DataProtection BackupVaults BackupPolicies `[Microsoft.DataProtection/backupVaults/backupPolicies]`

This module deploys DataProtection BackupVaults BackupPolicies.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataProtection/backupVaults/backupPolicies` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2022-03-01/backupVaults/backupPolicies) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `backupVaultName` | string | The name of the backup vault. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `backupPolicyProperties` | object | `{object}` | The properties of the backup policy. |
| `name` | string | `'DefaultPolicy'` | The name of the backup policy. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup policy. |
| `resourceGroupName` | string | The name of the resource group the backup policy was created in. |
| `resourceId` | string | The resource ID of the backup policy. |

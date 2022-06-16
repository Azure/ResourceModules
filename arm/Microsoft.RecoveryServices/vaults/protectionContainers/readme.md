# RecoveryServices Vaults ProtectionContainers `[Microsoft.RecoveryServices/vaults/protectionContainers]`

This module deploys RecoveryServices Vaults ProtectionContainers.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers` | [2022-02-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-02-01/vaults/backupFabrics/protectionContainers) |


## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Azure Recovery Service Vault Protection Container. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `recoveryVaultName` | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backupManagementType` | string | `''` | `[AzureBackupServer, AzureIaasVM, AzureSql, AzureStorage, AzureWorkload, DPM, DefaultBackup, Invalid, MAB, ]` | Backup management type to execute the current Protection Container job. |
| `containerType` | string | `''` | `[AzureBackupServerContainer, AzureSqlContainer, GenericContainer, Microsoft.ClassicCompute/virtualMachines, Microsoft.Compute/virtualMachines, SQLAGWorkLoadContainer, StorageContainer, VMAppContainer, Windows, ]` | Type of the container. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `friendlyName` | string | `''` |  | Friendly name of the Protection Container. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `protectedItems` | _[protectedItems](protectedItems/readme.md)_ array | `[]` |  | Protected items to register in the container. |
| `sourceResourceId` | string | `''` |  | Resource ID of the target resource for the Protection Container. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The Name of the Protection Container. |
| `resourceGroupName` | string | The name of the Resource Group the Protection Container was created in. |
| `resourceId` | string | The resource ID of the Protection Container. |

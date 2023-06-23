# Recovery Services Vault Protection Container `[Microsoft.RecoveryServices/vaults/protectionContainers]`

This module deploys a Recovery Services Vault Protection Container.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |

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
| `backupManagementType` | string | `''` | `['', AzureBackupServer, AzureIaasVM, AzureSql, AzureStorage, AzureWorkload, DefaultBackup, DPM, Invalid, MAB]` | Backup management type to execute the current Protection Container job. |
| `containerType` | string | `''` | `['', AzureBackupServerContainer, AzureSqlContainer, GenericContainer, Microsoft.ClassicCompute/virtualMachines, Microsoft.Compute/virtualMachines, SQLAGWorkLoadContainer, StorageContainer, VMAppContainer, Windows]` | Type of the container. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `friendlyName` | string | `''` |  | Friendly name of the Protection Container. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `protectedItems` | _[protectedItems](protected-items/README.md)_ array | `[]` |  | Protected items to register in the container. |
| `sourceResourceId` | string | `''` |  | Resource ID of the target resource for the Protection Container. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The Name of the Protection Container. |
| `resourceGroupName` | string | The name of the Resource Group the Protection Container was created in. |
| `resourceId` | string | The resource ID of the Protection Container. |

## Cross-referenced modules

_None_

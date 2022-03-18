# RecoveryServices Vaults ReplicationPolicies `[Microsoft.RecoveryServices/vaults/replicationPolicies]`

This module deploys a Replication Policy for Disaster Recovery scenario.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationPolicies` | 2021-12-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appConsistentFrequencyInMinutes` | int | `60` |  | Optional. The app consistent snapshot frequency (in minutes). |
| `crashConsistentFrequencyInMinutes` | int | `5` |  | Optional. The crash consistent snapshot frequency (in minutes). |
| `multiVmSyncStatus` | string | `Enable` | `[Enable, Disable]` | Optional. A value indicating whether multi-VM sync has to be enabled. |
| `name` | string |  |  | Required. The name of the replication policy |
| `recoveryPointHistory` | int | `1440` |  | Optional. The duration in minutes until which the recovery points need to be stored. |
| `recoveryVaultName` | string |  |  | Required. Name of the Azure Recovery Service Vault |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication policy. |
| `resourceGroupName` | string | The name of the resource group the replication policy was created in. |
| `resourceId` | string | The resource ID of the replication policy. |

## Template references

- [Vaults/Replicationpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-12-01/vaults/replicationPolicies)

# RecoveryServices Vaults ReplicationFabrics ReplicationProtectionContainers ReplicationProtectionContainerMappings `[Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings]`

This module deploys a Replication Protection Container Mapping.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | 2021-12-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `name` | string |  |  | Optional. The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`. |
| `policyId` | string |  |  | Optional. Resource ID of the replication policy. If defined, policyName will be ignored |
| `policyName` | string |  |  | Optional. Name of the replication policy. Will be ignored if policyId is also specified |
| `recoveryVaultName` | string |  |  | Required. Name of the Azure Recovery Service Vault |
| `replicationFabricName` | string |  |  | Required. Name of the Replication Fabric |
| `sourceProtectionContainerName` | string |  |  | Required. Name of the source Replication container |
| `targetContainerFabricName` | string | `replicationFabricName` |  | Optional. Name of the fabric containing the target container. If targetProtectionContainerId is specified, this parameter will be ignored |
| `targetContainerName` | string |  |  | Optional. Name of the target container. Must be specified if targetProtectionContainerId is not. If targetProtectionContainerId is specified, this parameter will be ignored |
| `targetProtectionContainerId` | string |  |  | Optional. Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication container. |
| `resourceGroupName` | string | The name of the resource group the replication container was created in. |
| `resourceId` | string | The resource ID of the replication container. |

## Template references

- [Vaults/Replicationfabrics/Replicationprotectioncontainers/Replicationprotectioncontainermappings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-12-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings)

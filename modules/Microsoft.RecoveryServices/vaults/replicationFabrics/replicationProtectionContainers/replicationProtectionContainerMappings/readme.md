# RecoveryServices Vaults ReplicationFabrics ReplicationProtectionContainers ReplicationProtectionContainerMappings `[Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings]`

This module deploys a Replication Protection Container Mapping.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | [2022-02-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-02-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings) |

## Parameters

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `recoveryVaultName` | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |
| `replicationFabricName` | string | The name of the parent Replication Fabric. Required if the template is used in a standalone deployment. |
| `sourceProtectionContainerName` | string | The name of the parent source Replication container. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `''` | The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`. |
| `policyId` | string | `''` | Resource ID of the replication policy. If defined, policyName will be ignored. |
| `policyName` | string | `''` | Name of the replication policy. Will be ignored if policyId is also specified. |
| `targetContainerFabricName` | string | `[parameters('replicationFabricName')]` | Name of the fabric containing the target container. If targetProtectionContainerId is specified, this parameter will be ignored. |
| `targetContainerName` | string | `''` | Name of the target container. Must be specified if targetProtectionContainerId is not. If targetProtectionContainerId is specified, this parameter will be ignored. |
| `targetProtectionContainerId` | string | `''` | Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication container. |
| `resourceGroupName` | string | The name of the resource group the replication container was created in. |
| `resourceId` | string | The resource ID of the replication container. |

## Cross-referenced modules

_None_

# Azure Container Registry (ACR) Replications `[Microsoft.ContainerRegistry/registries/replications]`

This module deploys an Azure Container Registry (ACR) Replication.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `registryName` | string | The name of the parent registry. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `regionEndpointEnabled` | bool | `True` |  | Specifies whether the replication regional endpoint is enabled. Requests will not be routed to a replication whose regional endpoint is disabled, however its data will continue to be synced with other replications. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `zoneRedundancy` | string | `'Disabled'` | `[Disabled, Enabled]` | Whether or not zone redundancy is enabled for this container registry. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the replication. |
| `resourceGroupName` | string | The name of the resource group the replication was created in. |
| `resourceId` | string | The resource ID of the replication. |

## Cross-referenced modules

_None_

# Synapse Workspaces Keys `[Microsoft.Synapse/workspaces/keys]`

This module deploys a Synapse Workspaces Key.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Synapse/workspaces/keys` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `isActiveCMK` | bool | Used to activate the workspace after a customer managed key is provided. |
| `name` | string | Encryption key name. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `workspaceName` | string | The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `keyVaultResourceId` | string | `''` | The resource ID of a key vault to reference a customer managed key for encryption from. |
| `location` | string | `[resourceGroup().location]` | The geo-location where the resource lives. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed key. |
| `resourceGroupName` | string | The resource group of the deployed key. |
| `resourceId` | string | The resource ID of the deployed key. |

## Template references

- [Workspaces/Keys](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys)

## Cross-referenced modules

_None_

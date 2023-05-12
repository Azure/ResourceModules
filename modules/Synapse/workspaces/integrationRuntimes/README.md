# Synapse Workspaces IntegrationRuntimes `[Microsoft.Synapse/workspaces/integrationRuntimes]`

This module deploys Synapse Workspaces IntegrationRuntimes.

## Navigation

- [Synapse Workspaces IntegrationRuntimes `[Microsoft.Synapse/workspaces/integrationRuntimes]`](#synapse-workspaces-integrationruntimes-microsoftsynapseworkspacesintegrationruntimes)
  - [Navigation](#navigation)
  - [Resource Types](#resource-types)
  - [Parameters](#parameters)
  - [Outputs](#outputs)
  - [Cross-referenced modules](#cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Synapse/workspaces/integrationRuntimes` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/integrationRuntimes) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `name` | string |  | The name of the Integration Runtime. |
| `type` | string | `[Managed, SelfHosted]` | The type of Integration Runtime. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `workspaceName` | string | The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `managedVirtualNetworkName` | string | `''` | The name of the Managed Virtual Network if using type "Managed" . |
| `typeProperties` | object | `{object}` | Integration Runtime type properties. Required if type is "Managed". |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Integration Runtime. |
| `resourceGroupName` | string | The name of the Resource Group the Integration Runtime was created in. |
| `resourceId` | string | The resource ID of the Integration Runtime. |

## Cross-referenced modules

_None_

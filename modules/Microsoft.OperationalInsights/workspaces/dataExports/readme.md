# Log Analytics Workspace Data Exports `[Microsoft.OperationalInsights/workspaces/dataExports]`

This module deploys Log Analytics Workspace Data Exports.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The data export rule name. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `workspaceName` | string | The name of the parent workspaces. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `destination` | object | `{object}` | Destination properties. |
| `enable` | bool | `False` | Active when enabled. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `tableNames` | array | `[]` | An array of tables to export, for example: ['Heartbeat', 'SecurityEvent']. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the data export. |
| `resourceGroupName` | string | The name of the resource group the data export was created in. |
| `resourceId` | string | The resource ID of the data export. |

## Cross-referenced modules

_None_

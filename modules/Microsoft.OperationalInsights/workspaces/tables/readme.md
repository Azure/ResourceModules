# Log Analytics Workspace Tables `[Microsoft.OperationalInsights/workspaces/tables]`

This module deploys Log Analytics Workspace Tables.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/tables` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the table. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `workspaceName` | string | The name of the parent workspaces. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `plan` | string | `'Analytics'` | `[Analytics, Basic]` | Instruct the system how to handle and charge the logs ingested to this table. |
| `restoredLogs` | object | `{object}` |  | Restore parameters. |
| `retentionInDays` | int | `-1` |  | The table retention in days, between 4 and 730. Setting this property to -1 will default to the workspace retention. |
| `schema` | object | `{object}` |  | Table's schema. |
| `searchResults` | object | `{object}` |  | Parameters of the search job that initiated this table. |
| `totalRetentionInDays` | int | `-1` |  | The table total retention in days, between 4 and 2555. Setting this property to -1 will default to table retention. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the table. |
| `resourceGroupName` | string | The name of the resource group the table was created in. |
| `resourceId` | string | The resource ID of the table. |

## Cross-referenced modules

_None_

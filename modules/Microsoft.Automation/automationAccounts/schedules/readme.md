# Automation Account Schedules `[Microsoft.Automation/automationAccounts/schedules]`

This module deploys an Azure Automation Account Schedule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/schedules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/schedules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Automation Account schedule. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `automationAccountName` | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `advancedSchedule` | object | `{object}` |  | The properties of the create Advanced Schedule. |
| `description` | string | `''` |  | The description of the schedule. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `expiryTime` | string | `''` |  | The end time of the schedule. |
| `frequency` | string | `'OneTime'` | `[Day, Hour, Minute, Month, OneTime, Week]` | The frequency of the schedule. |
| `interval` | int | `0` |  | Anything. |
| `startTime` | string | `''` |  | The start time of the schedule. |
| `timeZone` | string | `''` |  | The time zone of the schedule. |

**Generated parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('u')]` | Time used as a basis for e.g. the schedule start date. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed schedule. |
| `resourceGroupName` | string | The resource group of the deployed schedule. |
| `resourceId` | string | The resource ID of the deployed schedule. |

## Cross-referenced modules

_None_

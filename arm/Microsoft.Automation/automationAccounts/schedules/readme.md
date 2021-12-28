# Automation Account Schedules `[Microsoft.Automation/automationAccounts/schedules]`

This module deploys an Azure Automation Account Schedule.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/schedules` | 2020-01-13-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `advancedSchedule` | object | `{object}` |  | Optional. The properties of the create Advanced Schedule. |
| `automationAccountName` | string |  |  | Required. Name of the parent Automation Account. |
| `baseTime` | string | `[utcNow('u')]` |  | Optional. Time used as a basis for e.g. the schedule start date. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. |
| `expiryTime` | string |  |  | Optional. The end time of the schedule. |
| `frequency` | string | `OneTime` | `[Day, Hour, Minute, Month, OneTime, Week]` | Optional. The frequency of the schedule. |
| `interval` | int |  |  | Optional. Anything |
| `name` | string |  |  | Required. Name of the Automation Account schedule. |
| `scheduleDescription` | string |  |  | Optional. The description of the schedule. |
| `startTime` | string |  |  | Optional. The start time of the schedule. |
| `timeZone` | string |  |  | Optional. The time zone of the schedule. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `scheduleName` | string | The name of the deployed schedule |
| `scheduleResourceGroup` | string | The resource group of the deployed schedule |
| `scheduleResourceId` | string | The resource ID of the deployed schedule |

## Template references

- [Automationaccounts/Schedules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/schedules)

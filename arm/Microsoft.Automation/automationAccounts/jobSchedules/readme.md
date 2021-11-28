# Automation Account Job Schedules `[Microsoft.Automation/automationAccounts/jobSchedules]`

This module deploys an Azure Automation Account Job Schedule.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/jobSchedules` | 2020-01-13-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `automationAccountName` | string |  |  | Required. Name of the parent Automation Account. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. |
| `name` | string | `[newGuid()]` |  | Optional. Name of the Automation Account job schedule. Must be a GUID. If not provided, a new GUID is generated. |
| `parameters` | object | `{object}` |  | Optional. List of job properties. |
| `runbookName` | string |  |  | Required. The runbook property associated with the entity. |
| `runOn` | string |  |  | Optional. The hybrid worker group that the scheduled job should run on. |
| `scheduleName` | string |  |  | Required. The schedule property associated with the entity. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `jobScheduleName` | string | The name of the deployed jobSchedule |
| `jobScheduleResourceGroup` | string | The resource group of the deployed jobSchedule |
| `jobScheduleResourceId` | string | The resource ID of the deployed jobSchedule |

## Template references

- [Automationaccounts/Jobschedules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/jobSchedules)

# DevTest Lab Schedules `[Microsoft.DevTestLab/labs/schedules]`

This module deploys a DevTest Lab Schedule.

Lab schedules are used to modify the settings for auto-shutdown, auto-start for lab virtual machines.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/schedules` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/schedules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `name` | string | `[LabVmAutoStart, LabVmsShutdown]` | The name of the schedule. |
| `taskType` | string | `[LabVmsShutdownTask, LabVmsStartupTask]` | The task type of the schedule (e.g. LabVmsShutdownTask, LabVmsStartupTask). |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `labName` | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `dailyRecurrence` | object | `{object}` |  | If the schedule will occur once each day of the week, specify the daily recurrence. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `hourlyRecurrence` | object | `{object}` |  | If the schedule will occur multiple times a day, specify the hourly recurrence. |
| `notificationSettingsStatus` | string | `'Disabled'` | `[Disabled, Enabled]` | If notifications are enabled for this schedule (i.e. Enabled, Disabled). |
| `notificationSettingsTimeInMinutes` | int | `30` |  | Time in minutes before event at which notification will be sent. Optional if "notificationSettingsStatus" is set to "Enabled". Default is 30 minutes. |
| `status` | string | `'Enabled'` | `[Disabled, Enabled]` | The status of the schedule (i.e. Enabled, Disabled). |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `targetResourceId` | string | `''` |  | The resource ID to which the schedule belongs. |
| `timeZoneId` | string | `'Pacific Standard time'` |  | The time zone ID (e.g. Pacific Standard time). |
| `weeklyRecurrence` | object | `{object}` |  | If the schedule will occur only some days of the week, specify the weekly recurrence. |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the schedule. |
| `resourceGroupName` | string | The name of the resource group the schedule was created in. |
| `resourceId` | string | The resource ID of the schedule. |

## Cross-referenced modules

_None_

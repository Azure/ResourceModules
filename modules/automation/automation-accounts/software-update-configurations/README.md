# Automation Account Software Update Configurations `[Microsoft.Automation/automationAccounts/softwareUpdateConfigurations]`

This module deploys an Azure Automation Account Software Update Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/softwareUpdateConfigurations` | [2019-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/softwareUpdateConfigurations) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `frequency` | string | `[Day, Hour, Month, OneTime, Week]` | The frequency of the deployment schedule. When using 'Hour', 'Day', 'Week' or 'Month', an interval needs to be provided. |
| `name` | string |  | The name of the Deployment schedule. |
| `operatingSystem` | string | `[Linux, Windows]` | The operating system to be configured by the deployment schedule. |
| `rebootSetting` | string | `[Always, IfRequired, Never, RebootOnly]` | Reboot setting for the deployment schedule. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `automationAccountName` | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `azureVirtualMachines` | array | `[]` |  | List of azure resource IDs for azure virtual machines in scope for the deployment schedule. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `excludeUpdates` | array | `[]` |  | KB numbers or Linux packages excluded in the deployment schedule. |
| `expiryTime` | string | `''` |  | The end time of the deployment schedule in ISO 8601 format. YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00. |
| `expiryTimeOffsetMinutes` | int | `0` |  | The expiry time's offset in minutes. |
| `includeUpdates` | array | `[]` |  | KB numbers or Linux packages included in the deployment schedule. |
| `interval` | int | `1` |  | The interval of the frequency for the deployment schedule. 1 Hour is every hour, 2 Day is every second day, etc. |
| `isEnabled` | bool | `True` |  | Enables the deployment schedule. |
| `maintenanceWindow` | string | `'PT2H'` |  | Maximum time allowed for the deployment schedule to run. Duration needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. |
| `monthDays` | array | `[]` | `[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]` | Can be used with frequency 'Month'. Provides the specific days of the month to run the deployment schedule. |
| `monthlyOccurrences` | array | `[]` |  | Can be used with frequency 'Month'. Provides the pattern/cadence for running the deployment schedule in a month. Takes objects formed like this {occurance(int),day(string)}. Day is the name of the day to run the deployment schedule, the occurance specifies which occurance of that day to run the deployment schedule. |
| `nextRun` | string | `''` |  | The next time the deployment schedule runs in ISO 8601 format. YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00. |
| `nextRunOffsetMinutes` | int | `0` |  | The next run's offset in minutes. |
| `nonAzureComputerNames` | array | `[]` |  | List of names of non-azure machines in scope for the deployment schedule. |
| `nonAzureQueries` | array | `[]` |  | Array of functions from a Log Analytics workspace, used to scope the deployment schedule. |
| `postTaskParameters` | object | `{object}` |  | Parameters provided to the task running after the deployment schedule. |
| `postTaskSource` | string | `''` |  | The source of the task running after the deployment schedule. |
| `preTaskParameters` | object | `{object}` |  | Parameters provided to the task running before the deployment schedule. |
| `preTaskSource` | string | `''` |  | The source of the task running before the deployment schedule. |
| `scheduleDescription` | string | `''` |  | The schedules description. |
| `scopeByLocations` | array | `[]` |  | Specify locations to which to scope the deployment schedule to. |
| `scopeByResources` | array | `[[subscription().id]]` |  | Specify the resources to scope the deployment schedule to. |
| `scopeByTags` | object | `{object}` |  | Specify tags to which to scope the deployment schedule to. |
| `scopeByTagsOperation` | string | `'All'` | `[All, Any]` | Enables the scopeByTags to require All (Tag A and Tag B) or Any (Tag A or Tag B). |
| `startTime` | string | `''` |  | The start time of the deployment schedule in ISO 8601 format. To specify a specific time use YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00. For schedules where we want to start the deployment as soon as possible, specify the time segment only in 24 hour format, HH:MM, 22:00. |
| `timeZone` | string | `'UTC'` |  | Time zone for the deployment schedule. IANA ID or a Windows Time Zone ID. |
| `updateClassifications` | array | `[Critical, Security]` | `[Critical, Definition, FeaturePack, Other, Security, ServicePack, Tools, UpdateRollup, Updates]` | Update classification included in the deployment schedule. |
| `weekDays` | array | `[]` | `[Friday, Monday, Saturday, Sunday, Thursday, Tuesday, Wednesday]` | Required when used with frequency 'Week'. Specified the day of the week to run the deployment schedule. |

**Generated parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('u')]` | Do not touch. Is used to provide the base time for time comparison for startTime. If startTime is specified in HH:MM format, baseTime is used to check if the provided startTime has passed, adding one day before setting the deployment schedule. |


### Parameter Usage: `scopeByTags`

Provide tag keys, with an array of values, filtering in machines that should be included in the deployment schedule.

| Property name | Type  | Possible values | Description |
| :------------ | :---- | :-------------- | :---------- |
| \<tag key\>   | array | string          | tag values  |


<details>

<summary>Parameter JSON format</summary>

```json
"scopeByTags": {
    "value": {
        "Update": [
            "Automatic"
        ],
        "MaintenanceWindow": [
            "1-Sat-22"
        ]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
scopeByTags: {
    Update: [
        'Automatic'
    ]
    MaintenanceWindow: [
        '1-Sat-22'
    ]
}
```

</details>
<p>

### Parameter Usage: `monthlyOccurrences`

Occurrences of days within a month.

| Property name | Type   | Possible values                                                | Description                                                                          |
| :------------ | :----- | :------------------------------------------------------------- | :----------------------------------------------------------------------------------- |
| `occurance`   | int    | 1-5                                                            | Occurrence of the week within the month. Must be between 1 and 5, where 5 is "last". |
| `day`         | string | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday | Day of the occurrence.                                                               |

<details>

<summary>Parameter JSON format</summary>

```json
"monthlyOccurrences": {
    "value": [
        {
            "occurrence": 1,
            "day": "Monday"
        },
        {
            "occurrence": 2,
            "day": "Friday"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
monthlyOccurrences: [
    {
        occurrence: 1
        day: 'Monday'
    }
    {
        occurrence: 2
        day: 'Friday'
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed softwareUpdateConfiguration. |
| `resourceGroupName` | string | The resource group of the deployed softwareUpdateConfiguration. |
| `resourceId` | string | The resource ID of the deployed softwareUpdateConfiguration. |

## Cross-referenced modules

_None_

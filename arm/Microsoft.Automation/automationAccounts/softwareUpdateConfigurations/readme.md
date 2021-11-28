# Automation Account Software Update Configurations `[Microsoft.Automation/automationAccounts/softwareUpdateConfigurations]`

This module deploys an Azure Automation Account Software update Configuration.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/softwareUpdateConfigurations` | 2019-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `automationAccountName` | string |  |  | Required. Name of the parent Automation Account |
| `azureVirtualMachines` | array | `[]` |  | Optional. List of azure resource IDs for azure virtual machines in scope for the deployment schedule. |
| `baseTime` | string | `[utcNow('u')]` |  | Generated. Do not touch. Is used to provide the base time for time comparison for startTime. If startTime is specified in HH:MM format, baseTime is used to check if the provided startTime has passed, adding one day before setting the deployment schedule. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `excludeUpdates` | array | `[]` |  | Optional. KB numbers or Linux packages excluded in the deployment schedule. |
| `expiryTime` | string |  |  | Optional. The end time of the deployment schedule in ISO 8601 format. YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00 |
| `expiryTimeOffsetMinutes` | int |  |  | Optional. The expiry time's offset in minutes. |
| `frequency` | string |  | `[OneTime, Hour, Day, Week, Month]` | Required. The frequency of the deployment schedule. When using 'Hour', 'Day', 'Week' or 'Month', an interval needs to be provided. |
| `includeUpdates` | array | `[]` |  | Optional. KB numbers or Linux packages included in the deployment schedule. |
| `interval` | int | `1` |  | Optional. The interval of the frequency for the deployment schedule. 1 Hour is every hour, 2 Day is every second day, etc. |
| `isEnabled` | bool | `True` |  | Optional. Enables the deployment schedule. |
| `maintenanceWindow` | string | `PT2H` |  | Optional. Maximum time allowed for the deployment schedule to run. Duration needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601 |
| `monthDays` | array | `[]` | `[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]` | Optional. Can be used with frequency 'Month'. Provides the specific days of the month to run the deployment schedule. |
| `monthlyOccurrences` | array | `[]` |  | Optional. Can be used with frequency 'Month'. Provides the pattern/cadence for running the deployment schedule in a month. Takes objects formed like this {occurance(int),day(string)}. Day is the name of the day to run the deployment schedule, the occurance specifies which occurance of that day to run the deployment schedule. |
| `name` | string |  |  | Required. The name of the Deployment schedule. |
| `nextRun` | string |  |  | Optional. The next time the deployment schedule runs in ISO 8601 format. YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00 |
| `nextRunOffsetMinutes` | int |  |  | Optional. The next run's offset in minutes. |
| `nonAzureComputerNames` | array | `[]` |  | Optional. List of names of non-azure machines in scope for the deployment schedule. |
| `nonAzureQueries` | array | `[]` |  | Optional. Array of functions from a Log Analytics workspace, used to scope the deployment schedule. |
| `operatingSystem` | string |  | `[Windows, Linux]` | Required. The operating system to be configured by the deployment schedule. |
| `postTaskParameters` | object | `{object}` |  | Optional. Parameters provided to the task running after the deployment schedule. |
| `postTaskSource` | string |  |  | Optional. The source of the task running after the deployment schedule. |
| `preTaskParameters` | object | `{object}` |  | Optional. Parameters provided to the task running before the deployment schedule. |
| `preTaskSource` | string |  |  | Optional. The source of the task running before the deployment schedule. |
| `rebootSetting` | string |  | `[IfRequired, Never, RebootOnly, Always]` | Required. Reboot setting for the deployment schedule. |
| `scheduleDescription` | string |  |  | Optional. The schedules description. |
| `scopeByLocations` | array | `[]` |  | Optional. Specify locations to which to scope the deployment schedule to. |
| `scopeByResources` | array | `[[subscription().id]]` |  | Optional. Specify the resources to scope the deployment schedule to. |
| `scopeByTags` | object | `{object}` |  | Optional. Specify tags to which to scope the deployment schedule to. |
| `scopeByTagsOperation` | string | `All` | `[All, Any]` | Optional. Enables the scopeByTags to require All (Tag A and Tag B) or Any (Tag A or Tag B). |
| `startTime` | string |  |  | Optional. The start time of the deployment schedule in ISO 8601 format. To specify a specific time use YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00. For schedules where we want to start the deployment as soon as possible, specify the time segment only in 24 hour format, HH:MM, 22:00. |
| `timeZone` | string | `UTC` |  | Optional. Time zone for the deployment schedule. IANA ID or a Windows Time Zone ID. |
| `updateClassifications` | array | `[Critical, Security]` | `[Critical, Security, UpdateRollup, FeaturePack, ServicePack, Definition, Tools, Updates, Other]` | Optional. Update classification included in the deployment schedule. |
| `weekDays` | array | `[]` | `[Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday]` | Optional. Required when used with frequency 'Week'. Specified the day of the week to run the deployment schedule. |

### Parameter Usage: `scopeByTags`

Provide tag keys, with an array of values, filtering in machines that should be included in the deployment schedule.

| Property name | Type  | Possible values | Description |
| :------------ | :---- | :-------------- | :---------- |
| \<tag key\>   | array | string          | tag values  |

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

### Parameter Usage: `monthlyOccurrences`

Occurrences of days within a month.

| Property name | Type   | Possible values                                                | Description                                                                          |
| :------------ | :----- | :------------------------------------------------------------- | :----------------------------------------------------------------------------------- |
| `occurance`   | int    | 1-5                                                            | Occurrence of the week within the month. Must be between 1 and 5, where 5 is "last". |
| `day`         | string | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday | Day of the occurrence.                                                               |

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `softwareUpdateConfigurationName` | string | The name of the deployed softwareUpdateConfiguration |
| `softwareUpdateConfigurationResourceGroup` | string | The resource group of the deployed softwareUpdateConfiguration |
| `softwareUpdateConfigurationResourceId` | string | The resource ID of the deployed softwareUpdateConfiguration |

## Template references

- [Automationaccounts/Softwareupdateconfigurations](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/softwareUpdateConfigurations)

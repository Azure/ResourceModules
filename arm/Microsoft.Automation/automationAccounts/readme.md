# AutomationAccounts `[Microsoft.Automation/automationAccounts]`

This module deploys an Azure Automation Account, with resource lock.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Automation/automationAccounts` | 2020-01-13-preview |
| `Microsoft.Automation/automationAccounts/jobSchedules` | 2020-01-13-preview |
| `Microsoft.Automation/automationAccounts/modules` | 2020-01-13-preview |
| `Microsoft.Automation/automationAccounts/runbooks` | 2019-06-01 |
| `Microsoft.Automation/automationAccounts/schedules` | 2020-01-13-preview |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Network/privateEndpoints` | 2021-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `automationAccountName` | string |  |  | Required. Name of the Automation Account |
| `baseTime` | string | `[utcNow('u')]` |  | Optional. Time used as a basis for e.g. the schedule start date |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `jobSchedules` | array | `[]` |  | Optional. List of jobSchedules to be created in the automation account |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[JobLogs, JobStreams, DscNodeStatus]` | `[JobLogs, JobStreams, DscNodeStatus]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `modules` | array | `[]` |  | Optional. List of modules to be created in the automation account |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration Details for private endpoints. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `runbooks` | array | `[]` |  | Optional. List of runbooks to be created in the automation account |
| `sasTokenValidityLength` | string | `PT8H` |  | Optional. SAS token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| `schedules` | array | `[]` |  | Optional. List of schedules to be created in the automation account |
| `skuName` | string | `Basic` | `[Free, Basic]` | Optional. SKU name of the account |
| `tags` | object | `{object}` |  | Optional. Tags of the Automation Account resource. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

### Parameter Usage: `modules`

List of modules to be created in the automation account

```json
"modules": {
    "value": [
    {
        "name": "OMSIngestionAPI",                                    // The module name.
        "version": "latest",                                          // The module version or specify latest to get the latest version
        "uri": "https://www.powershellgallery.com/api/v2/package"     // The module package uri, e.g. https://www.powershellgallery.com/api/v2/package
    },
    {
        "name": "PackageManagement",
        "version": "1.4.5",
        "uri": "https://www.powershellgallery.com/api/v2/package"
    }
    ]
}
```

### Parameter Usage: `runbooks`

List of runbooks to be created in the automation account

```json
"runbooks": {
    "value": [
        {
            "runbookName": "ScalingRunbook", // Name for a runbook if you intent to deploy one
            "runbookType": "PowerShell", // Type of script
            "runbookScriptUri": "https://raw.githubusercontent.com/Azure/basicScale.ps1", // The uri where the runbook script is located
            "scriptStorageAccountId": "/subscriptions/62826c76-d304-46d8-a0f6-718dbdcc536c/resourceGroups/AVD-Mgmt-PO-RG/providers/Microsoft.Storage/storageAccounts/avdassetsstore",
            "version": "1.0.0.0" // version of api
        }
    ]
}
```

### Parameter Usage: `schedules`

List of schedules to be created in the automation account

```json
"schedules": {
    "value": [
        {
            "scheduleName": "ScalingRunbook_Schedule", // The schedule name.
            "startTime": "", // Gets or sets the start time of the schedule.
            "expiryTime": "9999-12-31T23:59:00+00:00", // Gets or sets the end time of the schedule.
            "interval": 15, // Gets or sets the interval of the schedule.
            "frequency": "Minute", // Gets or sets the frequency of the schedule. - OneTime, Day, Hour, Week, Month, Minute
            "timeZone": "Europe/Berlin", // Gets or sets the time zone of the schedule.
            "advancedSchedule": "" // Gets or sets the AdvancedSchedule
        }
    ]
}
```

### Parameter Usage: `jobSchedules`

List of jobSchedules to be created in the automation account

```json
"jobSchedules": {
    "value": [
        {
            "jobScheduleName": "ScalingRunbook_JobSchedule", // jobSchedule used to generate unique id
            "scheduleName": "ScalingRunbook_Schedule", // Gets or sets the schedule
            "runbookName": "ScalingRunbook", // Gets or sets the runbook
            "parameters": { // Gets or sets a list of job properties.
                "param1": "value1"
            },
            "runOn": "" // Gets or sets the hybrid worker group that the scheduled job should run on.
        }
    ]
}
```

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-sa-cac-y-123-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "blob",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
            ],
            "customDnsConfigs": [ // Optional
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "file"
        }
    ]
}
```

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Automation Contributor",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

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

## Outputs

| Output Name | Type |
| :-- | :-- |
| `automationAccountName` | string |
| `automationAccountResourceGroup` | string |
| `automationAccountResourceId` | string |
| `jobSchedules` | array |
| `modules` | array |
| `runbooks` | array |
| `schedules` | array |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Automationaccounts](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts)
- [Automationaccounts/Jobschedules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/jobSchedules)
- [Automationaccounts/Modules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/modules)
- [Automationaccounts/Runbooks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/runbooks)
- [Automationaccounts/Schedules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/schedules)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/privateEndpoints/privateDnsZoneGroups)

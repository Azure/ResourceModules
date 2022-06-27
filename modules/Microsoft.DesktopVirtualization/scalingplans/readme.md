# AVD Scaling Plans `[Microsoft.DesktopVirtualization/scalingPlans]`

This module deploys an AVD Scaling Plan.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.DesktopVirtualization/scalingPlans` | [2021-09-03-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2021-09-03-preview/scalingPlans) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the scaling plan. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `exclusionTag` | string | `''` |  | Provide a tag to be used for hosts that should not be affected by the scaling plan. |
| `friendlyName` | string | `[parameters('name')]` |  | Friendly Name of the scaling plan. |
| `hostPoolReferences` | array | `[]` |  | An array of references to hostpools. |
| `hostPoolType` | string | `'Pooled'` | `[Pooled]` | The type of hostpool where this scaling plan should be applied. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `logsToEnable` | array | `[Autoscale]` | `[Autoscale]` | The name of logs that will be streamed. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `scalingplanDescription` | string | `[parameters('name')]` |  | Description of the scaling plan. |
| `schedules` | array | `[System.Collections.Hashtable]` |  | The schedules related to this scaling plan. If no value is provided a default schedule will be provided. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `timeZone` | string | `'W. Europe Standard Time'` |  | Timezone to be used for the scaling plan. |


### Parameter Usage: `schedules`

Multiple schedules can be provided as needed. If a schedule is not provided, a default schedule will be created.

```json
"schedules" : {
    "value": [
        {
            "rampUpStartTime": {
                "hour": 7,
                "minute": 0
            },
            "peakStartTime": {
                "hour": 9,
                "minute": 0
            },
            "rampDownStartTime": {
                "hour": 18,
                "minute": 0
            },
            "offPeakStartTime": {
                "hour": 20,
                "minute": 0
            },
            "name": "weekdays_schedule",
            "daysOfWeek": [
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday"
            ],
            "rampUpLoadBalancingAlgorithm": "DepthFirst",
            "rampUpMinimumHostsPct": 20,
            "rampUpCapacityThresholdPct": 60,
            "peakLoadBalancingAlgorithm": "DepthFirst",
            "rampDownLoadBalancingAlgorithm": "DepthFirst",
            "rampDownMinimumHostsPct": 10,
            "rampDownCapacityThresholdPct": 90,
            "rampDownForceLogoffUsers": true,
            "rampDownWaitTimeMinutes": 30,
            "rampDownNotificationMessage": "You will be logged off in 30 min. Make sure to save your work.",
            "rampDownStopHostsWhen": "ZeroSessions",
            "offPeakLoadBalancingAlgorithm": "DepthFirst"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
'schedules': [
    {
        rampUpStartTime: {
            hour: 7
            minute: 0
        }
        peakStartTime: {
            hour: 9
            minute: 0
        }
        rampDownStartTime: {
            hour: 18
            minute: 0
        }
        offPeakStartTime: {
            hour: 20
            minute: 0
        }
        name: 'weekdays_schedule'
        daysOfWeek: [
            'Monday'
            'Tuesday'
            'Wednesday'
            'Thursday'
            'Friday'
        ]
        rampUpLoadBalancingAlgorithm: 'DepthFirst'
        rampUpMinimumHostsPct: 20
        rampUpCapacityThresholdPct: 60
        peakLoadBalancingAlgorithm: 'DepthFirst'
        rampDownLoadBalancingAlgorithm: 'DepthFirst'
        rampDownMinimumHostsPct: 10
        rampDownCapacityThresholdPct: 90
        rampDownForceLogoffUsers: true
        rampDownWaitTimeMinutes: 30
        rampDownNotificationMessage: 'You will be logged off in 30 min. Make sure to save your work.'
        rampDownStopHostsWhen: 'ZeroSessions'
        offPeakLoadBalancingAlgorithm: 'DepthFirst'
    }
]
```

</details>
<p>

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

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the AVD scaling plan. |
| `resourceGroupName` | string | The resource group the AVD scaling plan was deployed into. |
| `resourceId` | string | The resource ID of the AVD scaling plan. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-avdsp-x-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module scalingplans './Microsoft.DesktopVirtualization/scalingplans/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-scalingplans'
  params: {
    name: '<<namePrefix>>-az-avdsp-x-001'
  }
}
```

</details>
<p>

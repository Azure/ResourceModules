# Azure Virtual Desktop (AVD) Scaling Plans `[Microsoft.DesktopVirtualization/scalingPlans]`

This module deploys an Azure Virtual Desktop (AVD) Scaling Plan.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DesktopVirtualization/scalingPlans` | [2022-09-09](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2022-09-09/scalingPlans) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the scaling plan. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string | `[parameters('name')]` |  | Description of the scaling plan. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, Autoscale]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `exclusionTag` | string | `''` |  | Provide a tag to be used for hosts that should not be affected by the scaling plan. |
| `friendlyName` | string | `[parameters('name')]` |  | Friendly Name of the scaling plan. |
| `hostPoolReferences` | array | `[]` |  | An array of references to hostpools. |
| `hostPoolType` | string | `'Pooled'` | `[Pooled]` | The type of hostpool where this scaling plan should be applied. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `schedules` | array | `[System.Management.Automation.OrderedHashtable]` |  | The schedules related to this scaling plan. If no value is provided a default schedule will be provided. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `timeZone` | string | `'W. Europe Standard Time'` |  | Timezone to be used for the scaling plan. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the AVD scaling plan. |
| `resourceGroupName` | string | The resource group the AVD scaling plan was deployed into. |
| `resourceId` | string | The resource ID of the AVD scaling plan. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module scalingPlan './desktop-virtualization/scaling-plan/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dvspcom'
  params: {
    // Required parameters
    name: 'dvspcom001'
    // Non-required parameters
    description: 'My Scaling Plan Description'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    friendlyName: 'My Scaling Plan'
    hostPoolType: 'Pooled'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    schedules: [
      {
        daysOfWeek: [
          'Friday'
          'Monday'
          'Thursday'
          'Tuesday'
          'Wednesday'
        ]
        name: 'weekdays_schedule'
        offPeakLoadBalancingAlgorithm: 'DepthFirst'
        offPeakStartTime: {
          hour: 20
          minute: 0
        }
        peakLoadBalancingAlgorithm: 'DepthFirst'
        peakStartTime: {
          hour: 9
          minute: 0
        }
        rampDownCapacityThresholdPct: 90
        rampDownForceLogoffUsers: true
        rampDownLoadBalancingAlgorithm: 'DepthFirst'
        rampDownMinimumHostsPct: 10
        rampDownNotificationMessage: 'You will be logged off in 30 min. Make sure to save your work.'
        rampDownStartTime: {
          hour: 18
          minute: 0
        }
        rampDownStopHostsWhen: 'ZeroSessions'
        rampDownWaitTimeMinutes: 30
        rampUpCapacityThresholdPct: 60
        rampUpLoadBalancingAlgorithm: 'DepthFirst'
        rampUpMinimumHostsPct: 20
        rampUpStartTime: {
          hour: 7
          minute: 0
        }
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "dvspcom001"
    },
    // Non-required parameters
    "description": {
      "value": "My Scaling Plan Description"
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "friendlyName": {
      "value": "My Scaling Plan"
    },
    "hostPoolType": {
      "value": "Pooled"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "schedules": {
      "value": [
        {
          "daysOfWeek": [
            "Friday",
            "Monday",
            "Thursday",
            "Tuesday",
            "Wednesday"
          ],
          "name": "weekdays_schedule",
          "offPeakLoadBalancingAlgorithm": "DepthFirst",
          "offPeakStartTime": {
            "hour": 20,
            "minute": 0
          },
          "peakLoadBalancingAlgorithm": "DepthFirst",
          "peakStartTime": {
            "hour": 9,
            "minute": 0
          },
          "rampDownCapacityThresholdPct": 90,
          "rampDownForceLogoffUsers": true,
          "rampDownLoadBalancingAlgorithm": "DepthFirst",
          "rampDownMinimumHostsPct": 10,
          "rampDownNotificationMessage": "You will be logged off in 30 min. Make sure to save your work.",
          "rampDownStartTime": {
            "hour": 18,
            "minute": 0
          },
          "rampDownStopHostsWhen": "ZeroSessions",
          "rampDownWaitTimeMinutes": 30,
          "rampUpCapacityThresholdPct": 60,
          "rampUpLoadBalancingAlgorithm": "DepthFirst",
          "rampUpMinimumHostsPct": 20,
          "rampUpStartTime": {
            "hour": 7,
            "minute": 0
          }
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module scalingPlan './desktop-virtualization/scaling-plan/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dvspmin'
  params: {
    // Required parameters
    name: 'dvspmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "dvspmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

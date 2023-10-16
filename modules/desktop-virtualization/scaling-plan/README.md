# Azure Virtual Desktop (AVD) Scaling Plans `[Microsoft.DesktopVirtualization/scalingPlans]`

This module deploys an Azure Virtual Desktop (AVD) Scaling Plan.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DesktopVirtualization/scalingPlans` | [2022-09-09](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2022-09-09/scalingPlans) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/desktop-virtualization.scaling-plan:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module scalingPlan 'br:bicep/modules/desktop-virtualization.scaling-plan:1.0.0' = {
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module scalingPlan 'br:bicep/modules/desktop-virtualization.scaling-plan:1.0.0' = {
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the scaling plan. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Description of the scaling plan. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`exclusionTag`](#parameter-exclusiontag) | string | Provide a tag to be used for hosts that should not be affected by the scaling plan. |
| [`friendlyName`](#parameter-friendlyname) | string | Friendly Name of the scaling plan. |
| [`hostPoolReferences`](#parameter-hostpoolreferences) | array | An array of references to hostpools. |
| [`hostPoolType`](#parameter-hostpooltype) | string | The type of hostpool where this scaling plan should be applied. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`schedules`](#parameter-schedules) | array | The schedules related to this scaling plan. If no value is provided a default schedule will be provided. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`timeZone`](#parameter-timezone) | string | Timezone to be used for the scaling plan. |

### Parameter: `description`

Description of the scaling plan.
- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, Autoscale]`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `exclusionTag`

Provide a tag to be used for hosts that should not be affected by the scaling plan.
- Required: No
- Type: string
- Default: `''`

### Parameter: `friendlyName`

Friendly Name of the scaling plan.
- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `hostPoolReferences`

An array of references to hostpools.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `hostPoolType`

The type of hostpool where this scaling plan should be applied.
- Required: No
- Type: string
- Default: `'Pooled'`
- Allowed: `[Pooled]`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `name`

Name of the scaling plan.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `schedules`

The schedules related to this scaling plan. If no value is provided a default schedule will be provided.
- Required: No
- Type: array
- Default: `[System.Management.Automation.OrderedHashtable]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `timeZone`

Timezone to be used for the scaling plan.
- Required: No
- Type: string
- Default: `'W. Europe Standard Time'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the AVD scaling plan. |
| `resourceGroupName` | string | The resource group the AVD scaling plan was deployed into. |
| `resourceId` | string | The resource ID of the AVD scaling plan. |

## Cross-referenced modules

_None_

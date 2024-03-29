# Azure Virtual Desktop (AVD) Scaling Plans `[Microsoft.DesktopVirtualization/scalingPlans]`

> This module has already been migrated to [AVM](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res). Only the AVM version is expected to receive updates / new features. Please do not work on improving this module in [CARML](https://aka.ms/carml).

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

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/desktop-virtualization.scaling-plan:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

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

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module scalingPlan 'br:bicep/modules/desktop-virtualization.scaling-plan:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dvspmax'
  params: {
    // Required parameters
    name: 'dvspmax001'
    // Non-required parameters
    description: 'My Scaling Plan Description'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    friendlyName: 'My Scaling Plan'
    hostPoolType: 'Pooled'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
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
      "value": "dvspmax001"
    },
    // Non-required parameters
    "description": {
      "value": "My Scaling Plan Description"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
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
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module scalingPlan 'br:bicep/modules/desktop-virtualization.scaling-plan:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dvspwaf'
  params: {
    // Required parameters
    name: 'dvspwaf001'
    // Non-required parameters
    description: 'My Scaling Plan Description'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    friendlyName: 'My Scaling Plan'
    hostPoolType: 'Pooled'
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
      "value": "dvspwaf001"
    },
    // Non-required parameters
    "description": {
      "value": "My Scaling Plan Description"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the scaling plan. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Description of the scaling plan. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
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

### Parameter: `name`

Name of the scaling plan.

- Required: Yes
- Type: string

### Parameter: `description`

Description of the scaling plan.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

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
- Allowed:
  ```Bicep
  [
    'Pooled'
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `schedules`

The schedules related to this scaling plan. If no value is provided a default schedule will be provided.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
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
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

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

# Activity Log Alerts `[Microsoft.Insights/activityLogAlerts]`

This module deploys an Activity Log Alert.

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
| `Microsoft.Insights/activityLogAlerts` | [2020-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-10-01/activityLogAlerts) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/insights.activity-log-alert:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module activityLogAlert 'br:bicep/modules/insights.activity-log-alert:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ialacom'
  params: {
    // Required parameters
    conditions: [
      {
        equals: 'ServiceHealth'
        field: 'category'
      }
      {
        anyOf: [
          {
            equals: 'Incident'
            field: 'properties.incidentType'
          }
          {
            equals: 'Maintenance'
            field: 'properties.incidentType'
          }
        ]
      }
      {
        containsAny: [
          'Action Groups'
          'Activity Logs & Alerts'
        ]
        field: 'properties.impactedServices[*].ServiceName'
      }
      {
        containsAny: [
          'Global'
          'West Europe'
        ]
        field: 'properties.impactedServices[*].ImpactedRegions[*].RegionName'
      }
    ]
    name: 'ialacom001'
    // Non-required parameters
    actions: [
      {
        actionGroupId: '<actionGroupId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    scopes: [
      '<id>'
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
    "conditions": {
      "value": [
        {
          "equals": "ServiceHealth",
          "field": "category"
        },
        {
          "anyOf": [
            {
              "equals": "Incident",
              "field": "properties.incidentType"
            },
            {
              "equals": "Maintenance",
              "field": "properties.incidentType"
            }
          ]
        },
        {
          "containsAny": [
            "Action Groups",
            "Activity Logs & Alerts"
          ],
          "field": "properties.impactedServices[*].ServiceName"
        },
        {
          "containsAny": [
            "Global",
            "West Europe"
          ],
          "field": "properties.impactedServices[*].ImpactedRegions[*].RegionName"
        }
      ]
    },
    "name": {
      "value": "ialacom001"
    },
    // Non-required parameters
    "actions": {
      "value": [
        {
          "actionGroupId": "<actionGroupId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
    "scopes": {
      "value": [
        "<id>"
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
| [`conditions`](#parameter-conditions) | array | An Array of objects containing conditions that will cause this alert to activate. Conditions can also be combined with logical operators `allOf` and `anyOf`. Each condition can specify only one field between `equals` and `containsAny`. An alert rule condition must have exactly one category (Administrative, ServiceHealth, ResourceHealth, Alert, Autoscale, Recommendation, Security, or Policy). |
| [`name`](#parameter-name) | string | The name of the alert. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | array | The list of actions to take when alert triggers. |
| [`alertDescription`](#parameter-alertdescription) | string | Description of the alert. |
| [`enabled`](#parameter-enabled) | bool | Indicates whether this alert is enabled. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`scopes`](#parameter-scopes) | array | The list of resource IDs that this Activity Log Alert is scoped to. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `actions`

The list of actions to take when alert triggers.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `alertDescription`

Description of the alert.
- Required: No
- Type: string
- Default: `''`

### Parameter: `conditions`

An Array of objects containing conditions that will cause this alert to activate. Conditions can also be combined with logical operators `allOf` and `anyOf`. Each condition can specify only one field between `equals` and `containsAny`. An alert rule condition must have exactly one category (Administrative, ServiceHealth, ResourceHealth, Alert, Autoscale, Recommendation, Security, or Policy).
- Required: Yes
- Type: array

### Parameter: `enabled`

Indicates whether this alert is enabled.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `'global'`

### Parameter: `name`

The name of the alert.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `scopes`

The list of resource IDs that this Activity Log Alert is scoped to.
- Required: No
- Type: array
- Default: `[[subscription().id]]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the activity log alert. |
| `resourceGroupName` | string | The resource group the activity log alert was deployed into. |
| `resourceId` | string | The resource ID of the activity log alert. |

## Cross-referenced modules

_None_

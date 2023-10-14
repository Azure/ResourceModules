# Activity Log Alerts `[Microsoft.Insights/activityLogAlerts]`

This module deploys an Activity Log Alert.

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
| `Microsoft.Insights/activityLogAlerts` | [2020-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-10-01/activityLogAlerts) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `conditions` | array | An Array of objects containing conditions that will cause this alert to activate. Conditions can also be combined with logical operators `allOf` and `anyOf`. Each condition can specify only one field between `equals` and `containsAny`. An alert rule condition must have exactly one category (Administrative, ServiceHealth, ResourceHealth, Alert, Autoscale, Recommendation, Security, or Policy). |
| `name` | string | The name of the alert. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `actions` | array | `[]` | The list of actions to take when alert triggers. |
| `alertDescription` | string | `''` | Description of the alert. |
| `enabled` | bool | `True` | Indicates whether this alert is enabled. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `'global'` | Location for all resources. |
| `roleAssignments` | array | `[]` | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `scopes` | array | `[[subscription().id]]` | The list of resource IDs that this Activity Log Alert is scoped to. |
| `tags` | object | `{object}` | Tags of the resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the activity log alert. |
| `resourceGroupName` | string | The resource group the activity log alert was deployed into. |
| `resourceId` | string | The resource ID of the activity log alert. |

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
module activityLogAlert './insights/activity-log-alert/main.bicep' = {
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

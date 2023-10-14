# Scheduled Query Rules `[Microsoft.Insights/scheduledQueryRules]`

This module deploys a Scheduled Query Rule.

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
| `Microsoft.Insights/scheduledQueryRules` | [2021-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-02-01-preview/scheduledQueryRules) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/insights.scheduled-query-rule:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module scheduledQueryRule 'br:bicep/modules/insights.scheduled-query-rule:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-isqrcom'
  params: {
    // Required parameters
    criterias: {
      allOf: [
        {
          dimensions: [
            {
              name: 'Computer'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'InstanceName'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          metricMeasureColumn: 'AggregatedValue'
          operator: 'GreaterThan'
          query: 'Perf | where ObjectName == \'LogicalDisk\' | where CounterName == \'% Free Space\' | where InstanceName <> \'HarddiskVolume1\' and InstanceName <> \'_Total\' | summarize AggregatedValue = min(CounterValue) by Computer InstanceName bin(TimeGenerated5m)'
          threshold: 0
          timeAggregation: 'Average'
        }
      ]
    }
    name: 'isqrcom001'
    scopes: [
      '<logAnalyticsWorkspaceResourceId>'
    ]
    // Non-required parameters
    alertDescription: 'My sample Alert'
    autoMitigate: false
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    evaluationFrequency: 'PT5M'
    queryTimeRange: 'PT5M'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    suppressForMinutes: 'PT5M'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    windowSize: 'PT5M'
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
    "criterias": {
      "value": {
        "allOf": [
          {
            "dimensions": [
              {
                "name": "Computer",
                "operator": "Include",
                "values": [
                  "*"
                ]
              },
              {
                "name": "InstanceName",
                "operator": "Include",
                "values": [
                  "*"
                ]
              }
            ],
            "metricMeasureColumn": "AggregatedValue",
            "operator": "GreaterThan",
            "query": "Perf | where ObjectName == \"LogicalDisk\" | where CounterName == \"% Free Space\" | where InstanceName <> \"HarddiskVolume1\" and InstanceName <> \"_Total\" | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)",
            "threshold": 0,
            "timeAggregation": "Average"
          }
        ]
      }
    },
    "name": {
      "value": "isqrcom001"
    },
    "scopes": {
      "value": [
        "<logAnalyticsWorkspaceResourceId>"
      ]
    },
    // Non-required parameters
    "alertDescription": {
      "value": "My sample Alert"
    },
    "autoMitigate": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "evaluationFrequency": {
      "value": "PT5M"
    },
    "queryTimeRange": {
      "value": "PT5M"
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
    "suppressForMinutes": {
      "value": "PT5M"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "windowSize": {
      "value": "PT5M"
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
| [`criterias`](#parameter-criterias) | object | The rule criteria that defines the conditions of the scheduled query rule. |
| [`name`](#parameter-name) | string | The name of the Alert. |
| [`scopes`](#parameter-scopes) | array | The list of resource IDs that this scheduled query rule is scoped to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | array | Actions to invoke when the alert fires. |
| [`alertDescription`](#parameter-alertdescription) | string | The description of the scheduled query rule. |
| [`autoMitigate`](#parameter-automitigate) | bool | The flag that indicates whether the alert should be automatically resolved or not. Relevant only for rules of the kind LogAlert. |
| [`enabled`](#parameter-enabled) | bool | The flag which indicates whether this scheduled query rule is enabled. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`evaluationFrequency`](#parameter-evaluationfrequency) | string | How often the scheduled query rule is evaluated represented in ISO 8601 duration format. Relevant and required only for rules of the kind LogAlert. |
| [`kind`](#parameter-kind) | string | Indicates the type of scheduled query rule. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`queryTimeRange`](#parameter-querytimerange) | string | If specified (in ISO 8601 duration format) then overrides the query time range. Relevant only for rules of the kind LogAlert. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`severity`](#parameter-severity) | int | Severity of the alert. Should be an integer between [0-4]. Value of 0 is severest. Relevant and required only for rules of the kind LogAlert. |
| [`skipQueryValidation`](#parameter-skipqueryvalidation) | bool | The flag which indicates whether the provided query should be validated or not. Relevant only for rules of the kind LogAlert. |
| [`suppressForMinutes`](#parameter-suppressforminutes) | string | Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired. If set, autoMitigate must be disabled.Relevant only for rules of the kind LogAlert. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`targetResourceTypes`](#parameter-targetresourcetypes) | array | List of resource type of the target resource(s) on which the alert is created/updated. For example if the scope is a resource group and targetResourceTypes is Microsoft.Compute/virtualMachines, then a different alert will be fired for each virtual machine in the resource group which meet the alert criteria. Relevant only for rules of the kind LogAlert. |
| [`windowSize`](#parameter-windowsize) | string | The period of time (in ISO 8601 duration format) on which the Alert query will be executed (bin size). Relevant and required only for rules of the kind LogAlert. |

### Parameter: `actions`

Actions to invoke when the alert fires.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `alertDescription`

The description of the scheduled query rule.
- Required: No
- Type: string
- Default: `''`

### Parameter: `autoMitigate`

The flag that indicates whether the alert should be automatically resolved or not. Relevant only for rules of the kind LogAlert.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `criterias`

The rule criteria that defines the conditions of the scheduled query rule.
- Required: Yes
- Type: object

### Parameter: `enabled`

The flag which indicates whether this scheduled query rule is enabled.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `evaluationFrequency`

How often the scheduled query rule is evaluated represented in ISO 8601 duration format. Relevant and required only for rules of the kind LogAlert.
- Required: No
- Type: string
- Default: `''`

### Parameter: `kind`

Indicates the type of scheduled query rule.
- Required: No
- Type: string
- Default: `'LogAlert'`
- Allowed: `[LogAlert, LogToMetric]`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `name`

The name of the Alert.
- Required: Yes
- Type: string

### Parameter: `queryTimeRange`

If specified (in ISO 8601 duration format) then overrides the query time range. Relevant only for rules of the kind LogAlert.
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `scopes`

The list of resource IDs that this scheduled query rule is scoped to.
- Required: Yes
- Type: array

### Parameter: `severity`

Severity of the alert. Should be an integer between [0-4]. Value of 0 is severest. Relevant and required only for rules of the kind LogAlert.
- Required: No
- Type: int
- Default: `3`
- Allowed: `[0, 1, 2, 3, 4]`

### Parameter: `skipQueryValidation`

The flag which indicates whether the provided query should be validated or not. Relevant only for rules of the kind LogAlert.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `suppressForMinutes`

Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired. If set, autoMitigate must be disabled.Relevant only for rules of the kind LogAlert.
- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `targetResourceTypes`

List of resource type of the target resource(s) on which the alert is created/updated. For example if the scope is a resource group and targetResourceTypes is Microsoft.Compute/virtualMachines, then a different alert will be fired for each virtual machine in the resource group which meet the alert criteria. Relevant only for rules of the kind LogAlert.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `windowSize`

The period of time (in ISO 8601 duration format) on which the Alert query will be executed (bin size). Relevant and required only for rules of the kind LogAlert.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the created query rule. |
| `resourceGroupName` | string | The Resource Group of the created query rule. |
| `resourceId` | string | The resource ID of the created query rule. |

## Cross-referenced modules

_None_

# Metric Alerts `[Microsoft.Insights/metricAlerts]`

This module deploys a Metric Alert.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/metricAlerts` | [2018-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2018-03-01/metricAlerts) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `criterias` | array | Criterias to trigger the alert. Array of 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria' or 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria' objects. When using MultipleResourceMultipleMetricCriteria criteria type, some parameters becomes mandatory. It is not possible to convert from SingleResourceMultipleMetricCriteria to MultipleResourceMultipleMetricCriteria. The alert must be deleted and recreated. |
| `name` | string | The name of the alert. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `targetResourceRegion` | string | `''` | The region of the target resource(s) on which the alert is created/updated. Required if alertCriteriaType is MultipleResourceMultipleMetricCriteria. |
| `targetResourceType` | string | `''` | The resource type of the target resource(s) on which the alert is created/updated. Required if alertCriteriaType is MultipleResourceMultipleMetricCriteria. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actions` | array | `[]` |  | The list of actions to take when alert triggers. |
| `alertCriteriaType` | string | `'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'` | `[Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria, Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria, Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria]` | Maps to the 'odata.type' field. Specifies the type of the alert criteria. |
| `alertDescription` | string | `''` |  | Description of the alert. |
| `autoMitigate` | bool | `True` |  | The flag that indicates whether the alert should be auto resolved or not. |
| `enabled` | bool | `True` |  | Indicates whether this alert is enabled. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `evaluationFrequency` | string | `'PT5M'` | `[PT15M, PT1H, PT1M, PT30M, PT5M]` | how often the metric alert is evaluated represented in ISO 8601 duration format. |
| `location` | string | `'global'` |  | Location for all resources. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `scopes` | array | `[[subscription().id]]` |  | the list of resource IDs that this metric alert is scoped to. |
| `severity` | int | `3` | `[0, 1, 2, 3, 4]` | The severity of the alert. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `windowSize` | string | `'PT15M'` | `[P1D, PT12H, PT15M, PT1H, PT1M, PT30M, PT5M, PT6H]` | the period of time (in ISO 8601 duration format) that is used to monitor alert activity based on the threshold. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the metric alert. |
| `resourceGroupName` | string | The resource group the metric alert was deployed into. |
| `resourceId` | string | The resource ID of the metric alert. |

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
module metricAlert './insights/metric-alert/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-imacom'
  params: {
    // Required parameters
    criterias: [
      {
        criterionType: 'StaticThresholdCriterion'
        metricName: 'Percentage CPU'
        metricNamespace: 'microsoft.compute/virtualmachines'
        name: 'HighCPU'
        operator: 'GreaterThan'
        threshold: '90'
        timeAggregation: 'Average'
      }
    ]
    name: 'imacom001'
    // Non-required parameters
    actions: [
      '<actionGroupResourceId>'
    ]
    alertCriteriaType: 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
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
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    targetResourceRegion: 'westeurope'
    targetResourceType: 'microsoft.compute/virtualmachines'
    windowSize: 'PT15M'
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
      "value": [
        {
          "criterionType": "StaticThresholdCriterion",
          "metricName": "Percentage CPU",
          "metricNamespace": "microsoft.compute/virtualmachines",
          "name": "HighCPU",
          "operator": "GreaterThan",
          "threshold": "90",
          "timeAggregation": "Average"
        }
      ]
    },
    "name": {
      "value": "imacom001"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "<actionGroupResourceId>"
      ]
    },
    "alertCriteriaType": {
      "value": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
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
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "targetResourceRegion": {
      "value": "westeurope"
    },
    "targetResourceType": {
      "value": "microsoft.compute/virtualmachines"
    },
    "windowSize": {
      "value": "PT15M"
    }
  }
}
```

</details>
<p>

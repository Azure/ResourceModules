# Metric Alerts `[Microsoft.Insights/metricAlerts]`

This module deploys an alert based on metrics.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/metricAlerts` | 2018-03-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `criterias` | array | Criterias to trigger the alert. Array of 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria' or 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria' objects |
| `name` | string | The name of the alert. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actions` | array | `[]` |  | The list of actions to take when alert triggers. |
| `alertCriteriaType` | string | `'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'` | `[Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria, Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria, Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria]` | Maps to the 'odata.type' field. Specifies the type of the alert criteria. |
| `alertDescription` | string | `''` |  | Description of the alert. |
| `autoMitigate` | bool | `True` |  | The flag that indicates whether the alert should be auto resolved or not. |
| `enabled` | bool | `True` |  | Indicates whether this alert is enabled. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `evaluationFrequency` | string | `'PT5M'` | `[PT1M, PT5M, PT15M, PT30M, PT1H]` | how often the metric alert is evaluated represented in ISO 8601 duration format. |
| `location` | string | `'global'` |  | Location for all resources. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `scopes` | array | `[[subscription().id]]` |  | the list of resource IDs that this metric alert is scoped to. |
| `severity` | int | `3` | `[0, 1, 2, 3, 4]` | The severity of the alert. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `targetResourceRegion` | string | `''` |  | The region of the target resource(s) on which the alert is created/updated. Mandatory for MultipleResourceMultipleMetricCriteria. |
| `targetResourceType` | string | `''` |  | The resource type of the target resource(s) on which the alert is created/updated. Mandatory for MultipleResourceMultipleMetricCriteria. |
| `windowSize` | string | `'PT15M'` | `[PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D]` | the period of time (in ISO 8601 duration format) that is used to monitor alert activity based on the threshold. |


### Parameter Usage: actions

```json
"actions": {
  "value": [
    {
      "actionGroupId": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rgName/providers/microsoft.insights/actiongroups/ActionGroupName",
      "webhookProperties": {}
    }
  ]
}
```

`webhookProperties` is optional.

If you do only want to provide actionGroupIds, a shorthand use of the parameter is available.

```json
"actions": {
  "value": [
      "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rgName/providers/microsoft.insights/actiongroups/actionGroupName"
  ]
}
```

### Parameter Usage: criterias

**SingleResourceMultipleMetricCriteria**

```json
{
  "criterionType": "string",
  "dimensions": [],
  "metricName": "string",
  "metricNamespace": "string",
  "name": "string",
  "operator": "string",
  "threshold": "integer",
  "timeAggregation": "string"
}
```

**MultipleResourceMultipleMetricCriteria**

```json
{
  "criterionType": "string",
  "dimensions": [],
  "metricName": "string",
  "metricNamespace": "string",
  "name": "string",
  "operator": "string",
  "threshold": "integer",
  "timeAggregation": "string",
  "alertSensitivity": "string",
  "failingPeriods": {
    "minFailingPeriodsToAlert": "integer",
    "numberOfEvaluationPeriods": "integer"
  },
  "ignoreDataBefore": "string"
}
```

**Sample**
The following sample can be use both for Single and Multiple criterias. The other parameters are optional.

```json
"criterias":{
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
}
```

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

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

### Additional notes on parameters

- When using MultipleResourceMultipleMetricCriteria criteria type, some parameters becomes mandatory (see above)
- MultipleResourceMultipleMetricCriteria is suggested, as additional scopes can be added later
- It's not possible to convert from SingleResourceMultipleMetricCriteria to MultipleResourceMultipleMetricCriteria. Delete and re-create the alert.

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the metric alert |
| `resourceGroupName` | string | The resource group the metric alert was deployed into |
| `resourceId` | string | The resource ID of the metric alert |

## Template references

- [Metricalerts](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2018-03-01/metricAlerts)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

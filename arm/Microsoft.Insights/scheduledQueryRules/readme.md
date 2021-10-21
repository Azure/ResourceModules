# Scheduled Query Rules `[Microsoft.Insights/scheduledQueryRules]`

This module deploys an Alert based on metrics

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Insights/scheduledQueryRules` | 2018-04-16 |
| `microsoft.insights/scheduledQueryRules/providers/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actions` | array | `[]` |  | Optional. The list of actions to take when alert triggers. |
| `alertDescription` | string |  |  | Optional. Description of the alert. |
| `alertName` | string |  |  | Required. The name of the Alert. |
| `authorizedResources` | array | `[]` |  | Optional. The list of resource id's referenced in the query. |
| `breachesThreshold` | int | `3` |  | Optional. Number of threadshold violation to trigger the alert |
| `breachesThresholdOperator` | string | `GreaterThan` | `[GreaterThan, Equal, LessThan]` | Optional. If `metricColumn` is specified, operator for the breaches count evaluation to trigger the alert. Not used if using result count trigger. |
| `breachesTriggerType` | string | `Consecutive` | `[Consecutive, Total]` | Optional. Type of aggregation of threadshold violation |
| `criterias` | array | `[]` |  | Optional. The list of action alert creterias. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `enabled` | string | `true` | `[true, false]` | Optional. Indicates whether this alert is enabled. |
| `evaluationFrequency` | int | `5` | `[5, 10, 15, 30, 45, 60, 120, 180, 240, 300, 360, 1440]` | Optional. How often the metric alert is evaluated (in minutes). |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `metricColumn` | string |  |  | Optional. Variable (column) on which the query result will be grouped and then evaluated for trigger condition. Use comma to specify more than one. Leave empty to use "Number of results" type of alert logic |
| `metricResultCountThreshold` | int |  |  | Optional. Operator for metric or number of result evaluation. |
| `metricResultCountThresholdOperator` | string | `GreaterThan` | `[GreaterThan, Equal, LessThan]` | Optional. Operator of threshold breaches to trigger the alert. |
| `odataType` | string | `AlertingAction` | `[AlertingAction, LogToMetricAction]` | Optional. Type of the alert criteria. |
| `query` | string |  |  | Optional. The query to execute |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `severity` | int | `3` | `[0, 1, 2, 3, 4]` | Optional. The severity of the alert. |
| `suppressForMinutes` | int |  |  | Optional. Suppress Alert for (in minutes). |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `windowSize` | int | `60` | `[5, 10, 15, 30, 45, 60, 120, 180, 240, 300, 360, 1440, 2880]` | Optional. The period of time (in minutes) that is used to monitor alert activity based on the threshold. |
| `workspaceResourceId` | string |  |  | Required. Resource ID of the Log Analytics workspace where the query needs to be executed |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
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
| `deploymentResourceGroup` | string |
| `queryAlertName` | string |
| `queryAlertResourceId` | string |

## Template references

- [Scheduledqueryrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2018-04-16/scheduledQueryRules)

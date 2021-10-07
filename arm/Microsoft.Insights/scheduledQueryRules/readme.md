# Scheduled Query Rules

This module deploys an Alert based on metrics

## Resource types

| Resource Type                            | ApiVersion |
| :--------------------------------------- | :--------- |
| `Microsoft.Resources/deployments`        | 2018-02-01 |
| `microsoft.insights/scheduledQueryRules` | 2018-04-16 |

## Parameters

| Parameter Name                       | Type   | Description                                                                                                                                                                                                                                                                                                                                                                                                     | DefaultValue               | Possible values               |
| :----------------------------------- | :----- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------- | :---------------------------- |
| `actions`                            | array  | Optional. The list of actions to take when alert triggers.                                                                                                                                                                                                                                                                                                                                                      | System.Object[]            |                               |
| `alertDescription`                   | string | Optional. Description of the alert.                                                                                                                                                                                                                                                                                                                                                                             |                            |                               |
| `alertName`                          | string | Required. The name of the Alert.                                                                                                                                                                                                                                                                                                                                                                                |                            |                               |
| `authorizedResources`                | array  | Optional. The list of resource id's referenced in the query.                                                                                                                                                                                                                                                                                                                                                    | System.Object[]            |                               |
| `breachesThreshold`                  | int    | Optional. Number of threadshold violation to trigger the alert                                                                                                                                                                                                                                                                                                                                                  | 3                          |                               |
| `breachesThresholdOperator`          | string | Optional. If `metricColumn` is specified, operator for the breaches count evaluation to trigger the alert. Not used if using result count trigger.                                                                                                                                                                                                                                                              | GreaterThan                | System.Object[]               |
| `breachesTriggerType`                | string | Optional. Type of aggregation of threadshold violation                                                                                                                                                                                                                                                                                                                                                          | Consecutive                | System.Object[]               |
| `criterias`                          | array  | Optional. The list of action alert creterias.                                                                                                                                                                                                                                                                                                                                                                   | System.Object[]            |                               |
| `cuaId`                              | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered                                                                                                                                                                                                                                                                                                                         |                            |                               |
| `enabled`                            | string | Optional. Indicates whether this alert is enabled.                                                                                                                                                                                                                                                                                                                                                              | true                       | System.Object[]               |
| `evaluationFrequency`                | int    | Optional. How often the metric alert is evaluated (in minutes).                                                                                                                                                                                                                                                                                                                                                 | 5                          | System.Object[]               |
| `location`                           | string | Optional. Location for all resources.                                                                                                                                                                                                                                                                                                                                                                           | [resourceGroup().location] |                               |
| `metricColumn`                       | string | Optional. Variable (column) on which the query result will be grouped and then evaluated for trigger condition. Use comma to specify more than one. Leave empty to use "Number of results" type of alert logic                                                                                                                                                                                                  |                            |                               |
| `metricResultCountThreshold`         | int    | Optional. Operator for metric or number of result evaluation.                                                                                                                                                                                                                                                                                                                                                   | 0                          |                               |
| `metricResultCountThresholdOperator` | string | Optional. Operator of threshold breaches to trigger the alert.                                                                                                                                                                                                                                                                                                                                                  | GreaterThan                | System.Object[]               |
| `odataType`                          | string | Optional. Type of the alert criteria.                                                                                                                                                                                                                                                                                                                                                                           | AlertingAction             | System.Object[]               |
| `query`                              | string | Optional. The query to execute                                                                                                                                                                                                                                                                                                                                                                                  |                            |                               |
| `roleAssignments`                    | array  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | []                         | Complex structure, see below. |
| `severity`                           | int    | Optional. The severity of the alert.                                                                                                                                                                                                                                                                                                                                                                            | 3                          | System.Object[]               |
| `suppressForMinutes`                 | int    | Optional. Suppress Alert for (in minutes).                                                                                                                                                                                                                                                                                                                                                                      | 0                          |                               |
| `tags`                               | object | Optional. Tags of the resource.                                                                                                                                                                                                                                                                                                                                                                                 |                            |                               |
| `windowSize`                         | int    | Optional. The period of time (in minutes) that is used to monitor alert activity based on the threshold.                                                                                                                                                                                                                                                                                                        | 60                         | System.Object[]               |
| `workspaceResourceId`                | string | Required. Resource ID of the Log Analytics workspace where the query needs to be executed                                                                                                                                                                                                                                                                                                                       |                            |                               |

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

| Output Name               | Type   | Description                                                 |
| :------------------------ | :----- | :---------------------------------------------------------- |
| `queryAlertName`          | string | The Deployment Name.                                        |
| `queryAlertResourceId`    | string | The Resource Id of the Alert deployed.                      |
| `deploymentResourceGroup` | string | The name of the Resource Group the Resource was created in. |

## Considerations

## Additional resources

- [Log query based alerts](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-unified-log)
- [Template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/2018-04-16/scheduledqueryrules)
- [Kusto language](https://docs.microsoft.com/en-us/azure/kusto/query/)
- [Azure monitor documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/)

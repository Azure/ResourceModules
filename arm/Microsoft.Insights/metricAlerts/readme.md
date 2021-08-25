# Metric Alert
This module deploys an Alert based on metrics

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Insights/metricAlerts`|2018-03-01|
|`Microsoft.Insights/metricAlerts/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `actions` | array | Optional. The list of actions to take when alert triggers. | System.Object[] |  |
| `alertCriteriaType` | string | Optional. Maps to the 'odata.type' field. Specifies the type of the alert criteria. | Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria | System.Object[] |
| `alertDescription` | string | Optional. Description of the alert. |  |  |
| `alertName` | string | Required. The name of the Alert. |  |  |
| `autoMitigate` | bool | Optional. The flag that indicates whether the alert should be auto resolved or not. | True |  |    
| `criterias` | array | Required. Criterias to trigger the alert. Array of 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria' or 'Microsoft.Azure.Monitor. MultipleResourceMultipleMetricCriteria' objects |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `enabled` | bool | Optional. Indicates whether this alert is enabled. | True |  |
| `evaluationFrequency` | string | Optional. how often the metric alert is evaluated represented in ISO 8601 duration format. | PT5M | System.Object[] |
| `location` | string | Optional. Location for all resources. | global |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `scopes` | array | Required. the list of resource id's that this metric alert is scoped to. |  |  |
| `severity` | int | Optional. The severity of the alert. | 3 | System.Object[] |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `targetResourceRegion` | string | Optional. The region of the target resource(s) on which the alert is created/updated. Mandatory for MultipleResourceMultipleMetricCriteria. |  |  |
| `targetResourceType` | string | Optional. The resource type of the target resource(s) on which the alert is created/updated. Mandatory for MultipleResourceMultipleMetricCriteria. |  |  |
| `windowSize` | string | Optional. the period of time (in ISO 8601 duration format) that is used to monitor alert activity based on the threshold. | PT15M | System.Object[] |

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

### Additional notes on parameters
- When using MultipleResourceMultipleMetricCriteria criteria type, some parameters becomes mandatory (see above) 
- MultipleResourceMultipleMetricCriteria is suggested, as additional scopes can be added later
- It's not possible to convert from SingleResourceMultipleMetricCriteria to MultipleResourceMultipleMetricCriteria. Delete and re-create the alert.

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `alertName` | string | The name of the created database. |
| `deploymentResourceGroup` | string | The name of the Resource Group the Resource was created in. |
| `metricAlertResourceId` | string | The Resource Id of the Alert deployed. |

## Considerations

## Additional resources

- [Metric alerts](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric-overview)
- [Template reference](hhttps://docs.microsoft.com/en-us/azure/templates/microsoft.insights/2018-03-01/metricalerts)
- [Azure monitor documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/)
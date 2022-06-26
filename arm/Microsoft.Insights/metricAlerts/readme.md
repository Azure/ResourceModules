# Metric Alerts `[Microsoft.Insights/metricAlerts]`

This module deploys an alert based on metrics.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Insights/metricAlerts` | [2018-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2018-03-01/metricAlerts) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `criterias` | array | Criterias to trigger the alert. Array of 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria' or 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria' objects. |
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
| `alertCriteriaType` | string | `'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'` | `[Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria, Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria, Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria]` | Maps to the 'odata.type' field. Specifies the type of the alert criteria. |
| `alertDescription` | string | `''` |  | Description of the alert. |
| `autoMitigate` | bool | `True` |  | The flag that indicates whether the alert should be auto resolved or not. |
| `enabled` | bool | `True` |  | Indicates whether this alert is enabled. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `evaluationFrequency` | string | `'PT5M'` | `[PT1M, PT5M, PT15M, PT30M, PT1H]` | how often the metric alert is evaluated represented in ISO 8601 duration format. |
| `location` | string | `'global'` |  | Location for all resources. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `scopes` | array | `[[subscription().id]]` |  | the list of resource IDs that this metric alert is scoped to. |
| `severity` | int | `3` | `[0, 1, 2, 3, 4]` | The severity of the alert. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `windowSize` | string | `'PT15M'` | `[PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D]` | the period of time (in ISO 8601 duration format) that is used to monitor alert activity based on the threshold. |


### Parameter Usage: actions

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
actions: [
    {
        actionGroupId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rgName/providers/microsoft.insights/actiongroups/ActionGroupName'
        webhookProperties: {}
    }
]
```

</details>
<p>

`webhookProperties` is optional.

If you do only want to provide actionGroupIds, a shorthand use of the parameter is available.

<details>

<summary>Parameter JSON format</summary>

```json
"actions": {
  "value": [
      "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rgName/providers/microsoft.insights/actiongroups/actionGroupName"
  ]
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep


```

</details>

### Parameter Usage: `criteria`

**SingleResourceMultipleMetricCriteria**


<details>

<summary>Parameter JSON format</summary>

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

</details>


<details>

<summary>Bicep format</summary>

```bicep
{
    criterionType: 'string'
    dimensions: []
    metricName: 'string'
    metricNamespace: 'string'
    name: 'string'
    operator: 'string'
    threshold: 'integer'
    timeAggregation: 'string'
}
```

</details>
<p>

**MultipleResourceMultipleMetricCriteria**

<details>

<summary>Parameter JSON format</summary>

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

</details>


<details>

<summary>Bicep format</summary>

```bicep
{
    criterionType: 'string'
    dimensions: []
    metricName: 'string'
    metricNamespace: 'string'
    name: 'string'
    operator: 'string'
    threshold: 'integer'
    timeAggregation: 'string'
    alertSensitivity: 'string'
    failingPeriods: {
        minFailingPeriodsToAlert: 'integer'
        numberOfEvaluationPeriods: 'integer'
    }
    ignoreDataBefore: 'string'
}
```

</details>
<p>

**Sample**
The following sample can be use both for Single and Multiple criteria. The other parameters are optional.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
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
```

</details>
<p>

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Additional notes on parameters

- When using MultipleResourceMultipleMetricCriteria criteria type, some parameters becomes mandatory (see above)
- MultipleResourceMultipleMetricCriteria is suggested, as additional scopes can be added later
- It's not possible to convert from SingleResourceMultipleMetricCriteria to MultipleResourceMultipleMetricCriteria. Delete and re-create the alert.

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the metric alert. |
| `resourceGroupName` | string | The resource group the metric alert was deployed into. |
| `resourceId` | string | The resource ID of the metric alert. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-ma-x-001"
        },
        "windowSize": {
            "value": "PT15M"
        },
        "actions": {
            "value": [
                "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/microsoft.insights/actiongroups/adp-<<namePrefix>>-az-ag-x-001"
            ]
        },
        "targetResourceType": {
            "value": "microsoft.compute/virtualmachines"
        },
        "targetResourceRegion": {
            "value": "westeurope"
        },
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
        "alertCriteriaType": {
            "value": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module metricAlerts './Microsoft.Insights/metricAlerts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-metricAlerts'
  params: {
    name: '<<namePrefix>>-az-ma-x-001'
    windowSize: 'PT15M'
    actions: [
      '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/microsoft.insights/actiongroups/adp-<<namePrefix>>-az-ag-x-001'
    ]
    targetResourceType: 'microsoft.compute/virtualmachines'
    targetResourceRegion: 'westeurope'
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
    alertCriteriaType: 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
  }
}
```

</details>
<p>

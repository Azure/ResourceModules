# Scheduled Query Rules `[Microsoft.Insights/scheduledQueryRules]`

This module deploys a scheduled query rule.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/scheduledQueryRules` | 2021-02-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actions` | array | `[]` |  | Optional. Actions to invoke when the alert fires. |
| `alertDescription` | string |  |  | Optional. The description of the scheduled query rule. |
| `autoMitigate` | bool | `True` |  | Optional. The flag that indicates whether the alert should be automatically resolved or not. Relevant only for rules of the kind LogAlert. |
| `criterias` | object | `{object}` |  | Optional. The rule criteria that defines the conditions of the scheduled query rule. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `enabled` | bool | `True` |  | Optional. The flag which indicates whether this scheduled query rule is enabled. |
| `evaluationFrequency` | string |  |  | Optional. How often the scheduled query rule is evaluated represented in ISO 8601 duration format. Relevant and required only for rules of the kind LogAlert. |
| `kind` | string | `LogAlert` | `[LogAlert, LogToMetric]` | Optional. Indicates the type of scheduled query rule. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `name` | string |  |  | Required. The name of the Alert. |
| `queryTimeRange` | string |  |  | Optional. If specified (in ISO 8601 duration format) then overrides the query time range. Relevant only for rules of the kind LogAlert. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `scopes` | array | `[]` |  | Required. The list of resource IDs that this scheduled query rule is scoped to. |
| `severity` | int | `3` | `[0, 1, 2, 3, 4]` | Optional. Severity of the alert. Should be an integer between [0-4]. Value of 0 is severest. Relevant and required only for rules of the kind LogAlert. |
| `skipQueryValidation` | bool |  |  | Optional. The flag which indicates whether the provided query should be validated or not. Relevant only for rules of the kind LogAlert. |
| `suppressForMinutes` | string |  |  | Optional. Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired. If set, autoMitigate must be disabled.Relevant only for rules of the kind LogAlert. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `targetResourceTypes` | array | `[]` |  | Optional. List of resource type of the target resource(s) on which the alert is created/updated. For example if the scope is a resource group and targetResourceTypes is Microsoft.Compute/virtualMachines, then a different alert will be fired for each virtual machine in the resource group which meet the alert criteria. Relevant only for rules of the kind LogAlert |
| `windowSize` | string |  |  | Optional. The period of time (in ISO 8601 duration format) on which the Alert query will be executed (bin size). Relevant and required only for rules of the kind LogAlert. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `deploymentResourceGroup` | string | The Resource Group of the created query rule. |
| `queryAlertName` | string | The Name of the created query rule. |
| `queryAlertResourceId` | string | The resource ID of the created query rule. |

## Template references

- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-04-01-preview/roleAssignments)
- [Scheduledqueryrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-02-01-preview/scheduledQueryRules)

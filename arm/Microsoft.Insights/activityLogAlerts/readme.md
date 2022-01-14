# Activity Log Alerts `[Microsoft.Insights/activityLogAlerts]`

This module deploys an Alert based on Activity Log.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/activityLogAlerts` | 2020-10-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actions` | array | `[]` |  | Optional. The list of actions to take when alert triggers. |
| `alertDescription` | string |  |  | Optional. Description of the alert. |
| `conditions` | array |  |  | Required. The condition that will cause this alert to activate. Array of objects |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `enabled` | bool | `True` |  | Optional. Indicates whether this alert is enabled. |
| `location` | string | `global` |  | Optional. Location for all resources. |
| `name` | string |  |  | Required. The name of the alert. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `scopes` | array | `[[subscription().id]]` |  | Required. the list of resource IDs that this metric alert is scoped to. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |

### Parameter Usage: actions

```json
"actions": {
  "value": [
    {
      "actionGroupId": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rgName/providers/microsoft.insights/actiongroups/actionGroupName",
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

### Parameter Usage: conditions

**Conditions can also be combined with logical operators `allOf` and `anyOf`**

```json
{
  "field": "string",
  "equals": "string",
  "containsAny": "array"
}
```

Each condition can specify only one field between `equals` and `containsAny`.

| Parameter Name | Type             | Possible values                                                                                                                                                                                                   | Description                                                                                                                             |
| :------------- | :--------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------- |
| `field`        | string           | `resourceId`,<br>`category`,<br>`caller`,<br>`level`,<br>`operationName`,<br>`resourceGroup`,<br>`resourceProvider`,<br>`status`,<br>`subStatus`,<br>`resourceType`,<br> or anything beginning with `properties.` | Required. The name of the field that this condition will examine.                                                                       |
| `equals`       | string           |                                                                                                                                                                                                                   | Optional (Alternative to `containsAny`). The value to confront with.                                                                    |
| `containsAny`  | array of strings |                                                                                                                                                                                                                   | Optional (Alternative to `equals`). Condition will be satisfied if value of the field in the event is within one of the specified here. |

**Sample**

```json
"conditions":{
  "value":  [
      {
          "field": "category",
          "equals": "Administrative"
      },
      {
          "field": "resourceType",
          "equals": "microsoft.compute/virtualmachines"
      },
      {
          "field": "operationName",
          "equals": "Microsoft.Compute/virtualMachines/performMaintenance/action"
      }
  ]
}
```

**Sample 2**

```json
"conditions":{
    "value": [
        {
            "field": "category",
            "equals": "ServiceHealth"
        },
        {
            "anyOf": [
                {
                    "field": "properties.incidentType",
                    "equals": "Incident"
                },
                {
                    "field": "properties.incidentType",
                    "equals": "Maintenance"
                }
            ]
        },
        {
            "field": "properties.impactedServices[*].ServiceName",
            "containsAny": [
                "Action Groups",
                "Activity Logs & Alerts"
            ]
        },
        {
            "field": "properties.impactedServices[*].ImpactedRegions[*].RegionName",
            "containsAny": [
                "West Europe",
                "Global"
            ]
        }
    ]
}
```

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
| `activityLogAlertName` | string | The name of the activity log alert |
| `activityLogAlertResourceGroup` | string | The resource group the activity log alert was deployed into |
| `activityLogAlertResourceId` | string | The resource ID of the activity log alert |

## Template references

- [Activitylogalerts](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-10-01/activityLogAlerts)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-04-01-preview/roleAssignments)

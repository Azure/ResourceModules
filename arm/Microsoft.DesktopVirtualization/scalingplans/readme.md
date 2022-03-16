# DesktopVirtualization ScalingPlans `[Microsoft.DesktopVirtualization/scalingPlans]`

This module deploys DesktopVirtualization ScalingPlans.
// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.DesktopVirtualization/scalingPlans` | 2021-09-03-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. |
| `exclusionTag` | string |  |  | Optional. Provide a tag to be used for hosts that should not be affected by the scaling plan. |
| `friendlyName` | string | `[parameters('name')]` |  | Optional. Friendly Name of the scaling plan |
| `hostPoolReferences` | array | `[]` |  | Optional. An array of references to hostpools. |
| `hostPoolType` | string | `Pooled` | `[Pooled]` | Optional. The type of hostpool where this scaling plan should be applied. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `logsToEnable` | array | `[Autoscale]` | `[Autoscale]` | Optional. The name of logs that will be streamed. |
| `name` | string |  |  | Required. Name of the scaling plan |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `scalingplanDescription` | string | `[parameters('name')]` |  | Optional. Description of the scaling plan. |
| `schedules` | array | `[System.Collections.Hashtable]` |  | Optional. The schedules related to this scaling plan. If no value is provided a default schedule will be provided. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `timeZone` | string | `W. Europe Standard Time` |  | Optional. Timezone to be used for the scaling plan. |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

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

### Parameter Usage: `roleAssignments`

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
            ]
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the AVD scaling plan |
| `resourceGroupName` | string | The resource group the AVD scaling plan was deployed into |
| `resourceId` | string | The resource ID of the AVD scaling plan |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Scalingplans](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2021-09-03-preview/scalingPlans)

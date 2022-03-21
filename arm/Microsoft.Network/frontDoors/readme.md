# Network FrontDoors `[Microsoft.Network/frontDoors]`

This module deploys Network FrontDoors.


## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/frontDoors` | 2020-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backendPools` | array | `[]` |  | Required. Backend address pool of the frontdoor resource. |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.  |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enabledState` | string | `Enabled` |  | Required. State of the frontdoor resource. |
| `enforceCertificateNameCheck` | string | `Disabled` |  | Optional. Enforce certificate name check of the frontdoor resource. |
| `friendlyName` | string |  |  | Required. Friendly name of the frontdoor resource. |
| `frontendEndpoints` | array | `[]` |  | Required. Frontend endpoints of the frontdoor resource. |
| `healthProbeSettings` | array | `[]` |  | Required. Heath probe settings of the frontdoor resource. |
| `loadBalancingSettings` | array | `[]` |  | Required. Load balancing settings of the frontdoor resource. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[FrontdoorAccessLog, FrontdoorWebApplicationFirewallLog]` | `[FrontdoorAccessLog, FrontdoorWebApplicationFirewallLog]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. The name of the frontDoor. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `routingRules` | array | `[]` |  | Required. Routing rules settings of the frontdoor resource. |
| `sendRecvTimeoutSeconds` | int | `600` |  | Optional. Certificate name check time of the frontdoor resource. |
| `tags` | object | `{object}` |  | Optional. Resource tags. |




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
| `name` | string | The name of the front door |
| `resourceGroupName` | string | The resource group the front door was deployed into |
| `resourceId` | string | The resource ID of the front door |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Frontdoors](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/frontDoors)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

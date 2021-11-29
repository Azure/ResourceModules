# Web/Function App `[Microsoft.Web/sites]`

This module deploys a web or function app.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/components` | 2020-02-02 |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Network/privateEndpoints` | 2021-03-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-03-01 |
| `Microsoft.Web/serverfarms` | 2021-02-01 |
| `Microsoft.Web/sites` | 2020-12-01 |
| `Microsoft.Web/sites/config` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appInsightId` | string |  |  | Optional. The resource ID of the existing app insight to leverage for the app. If the resource ID is not provided, the appInsightObject can be used to create a new app insight. |
| `appInsightObject` | object | `{object}` |  | Optional. Used to deploy a new app insight if no appInsightId is provided. |
| `appServiceEnvironmentId` | string |  |  | Optional. The resource ID of the app service environment to use for this resource. |
| `appServicePlanId` | string |  |  | Optional. The resource ID of the app service plan to use for the site. If not provided, the appServicePlanObject is used to create a new plan. |
| `appServicePlanObject` | object | `{object}` |  | Optional. Required if no appServicePlanId is provided to deploy a new app service plan. |
| `clientAffinityEnabled` | bool | `True` |  | Optional. If client affinity is enabled. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the event hub namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `functionsExtensionVersion` | string | `~3` |  | Optional. Version if the function extension. |
| `functionsWorkerRuntime` | string |  | `[dotnet, node, python, java, powershell, ]` | Optional. Runtime of the function worker. |
| `httpsOnly` | bool | `True` |  | Optional. Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests. |
| `kind` | string |  | `[functionapp, app]` | Required. Type of site to deploy. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all Resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[AppServiceHTTPLogs, AppServiceConsoleLogs, AppServiceAppLogs, AppServiceFileAuditLogs, AppServiceAuditLogs]` | `[AppServiceHTTPLogs, AppServiceConsoleLogs, AppServiceAppLogs, AppServiceFileAuditLogs, AppServiceAuditLogs]` | Optional. The name of logs that will be streamed. |
| `managedServiceIdentity` | string | `None` | `[None, SystemAssigned, SystemAssigned, UserAssigned, UserAssigned]` | Optional. Type of managed service identity. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. Name of the site. |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration details for private endpoints. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `siteConfig` | object | `{object}` |  | Optional. Configuration of the app. |
| `storageAccountId` | string |  |  | Optional. Required if functionapp kind. The resource ID of the storage account to manage triggers and logging function executions. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. Mandatory 'managedServiceIdentity' contains UserAssigned. The identity to assign to the resource. |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics workspace. |

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
| `siteName` | string | The name of the site. |
| `siteResourceGroup` | string | The resource group the site was deployed into. |
| `siteResourceId` | string | The resource ID of the site. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Components](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/privateEndpoints/privateDnsZoneGroups)
- [Serverfarms](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-02-01/serverfarms)
- [Sites](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2020-12-01/sites)
- [Sites/Config](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-02-01/sites/config)

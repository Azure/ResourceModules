# Web/Function App `[Microsoft.Web/sites]`

This module deploys a Web or Function App

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Insights/components` | 2020-02-02 |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Network/privateEndpoints` | 2021-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-02-01 |
| `Microsoft.Web/serverfarms` | 2021-02-01 |
| `Microsoft.Web/sites` | 2020-12-01 |
| `Microsoft.Web/sites/config` | 2019-08-01 |
| `Microsoft.Web/sites/providers/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appName` | string |  |  | Required. Name of the Web Application Portal Name |
| `appServiceEnvironmentId` | string |  |  | Optional. The Resource Id of the App Service Environment to use for the Function App. |
| `appServicePlanFamily` | string |  |  | Optional. SkuFamily of app service plan deployed if no appServicePlanId was provided. |
| `appServicePlanId` | string |  |  | Optional. The Resource Id of the App Service Plan to use for the App. If not provided, the hosting plan name is used to create a new plan. |
| `appServicePlanName` | string |  |  | Optional. Required if no appServicePlanId is provided to deploy a new app service plan. |
| `appServicePlanSize` | string |  |  | Optional. SkuSize of app service plan deployed if no appServicePlanId was provided. |
| `appServicePlanSkuName` | string | `F1` | `[F1, D1, B1, B2, B3, S1, S2, S3, P1, P1v2, P2, P3, P4]` | Optional. The pricing tier for the hosting plan. |
| `appServicePlanTier` | string |  |  | Optional. SkuTier of app service plan deployed if no appServicePlanId was provided. |
| `appServicePlanType` | string | `linux` | `[linux, windows]` | Optional. SkuType of app service plan deployed if no appServicePlanId was provided. |
| `appServicePlanWorkerSize` | int | `2` |  | Optional. Defines the number of workers from the worker pool that will be used by the app service plan |
| `appType` | string |  | `[functionapp, app]` | Required. Type of site to deploy |
| `clientAffinityEnabled` | bool | `True` |  | Optional. If Client Affinity is enabled. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `enableMonitoring` | bool | `True` |  | Optional. If true, ApplicationInsights will be configured for the Function App. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `functionsExtensionVersion` | string | `~3` |  | Optional. Version if the function extension. |
| `functionsWorkerRuntime` | string |  | `[dotnet, node, python, java, powershell, ]` | Optional. Runtime of the function worker. |
| `httpsOnly` | bool | `True` |  | Optional. Configures a web site to accept only https requests. Issues redirect for http requests. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all Resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[AppServiceHTTPLogs, AppServiceConsoleLogs, AppServiceAppLogs, AppServiceFileAuditLogs, AppServiceAuditLogs]` | `[AppServiceHTTPLogs, AppServiceConsoleLogs, AppServiceAppLogs, AppServiceFileAuditLogs, AppServiceAuditLogs]` | Optional. The name of logs that will be streamed. |
| `managedServiceIdentity` | string | `None` | `[None, SystemAssigned, SystemAssigned, UserAssigned, UserAssigned]` | Optional. Type of managed service identity. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration Details for private endpoints. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `siteConfig` | object | `{object}` |  | Required. Configuration of the app. |
| `storageAccountName` | string |  |  | Optional. The name of the storage account to managing triggers and logging function executions. |
| `storageAccountResourceGroupName` | string | `[resourceGroup().name]` |  | Optional. Resource group of the storage account to use. Required if the storage account is in a different resource group than the function app itself. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. Mandatory 'managedServiceIdentity' contains UserAssigned. The identy to assign to the resource. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

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
| `siteName` | string |
| `siteResourceGroup` | string |
| `siteResourceId` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Components](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/privateEndpoints/privateDnsZoneGroups)
- [Serverfarms](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-02-01/serverfarms)
- [Sites](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2020-12-01/sites)
- [Sites/Config](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2019-08-01/sites/config)

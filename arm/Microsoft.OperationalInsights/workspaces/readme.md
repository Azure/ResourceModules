# Log Analytics Workspaces `[Microsoft.OperationalInsights/workspaces]`

This template deploys a log analytics workspace.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.OperationalInsights/workspaces` | 2020-08-01 |
| `Microsoft.OperationalInsights/workspaces/dataSources` | 2020-08-01 |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2020-08-01 |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | 2020-08-01 |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | 2020-08-01 |
| `Microsoft.OperationsManagement/solutions` | 2015-11-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `dailyQuotaGb` | int | `-1` |  | Optional. The workspace daily quota for ingestion. |
| `dataRetention` | int | `365` |  | Required. Number of days data will be retained for |
| `dataSources` | _[dataSources](dataSources/readme.md)_ array | `[]` |  | Optional. LAW data sources to configure. |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of a log analytics workspace. |
| `gallerySolutions` | array | `[]` |  | Optional. LAW gallerySolutions from the gallery. |
| `linkedServices` | _[linkedServices](linkedServices/readme.md)_ array | `[]` |  | Optional. List of services to be linked. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[Audit]` | `[Audit]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. Name of the Log Analytics workspace |
| `publicNetworkAccessForIngestion` | string | `Enabled` | `[Enabled, Disabled]` | Optional. The network access type for accessing Log Analytics ingestion. |
| `publicNetworkAccessForQuery` | string | `Enabled` | `[Enabled, Disabled]` | Optional. The network access type for accessing Log Analytics query. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `savedSearches` | _[savedSearches](savedSearches/readme.md)_ array | `[]` |  | Optional. Kusto Query Language searches to save. |
| `serviceTier` | string | `PerGB2018` | `[Free, Standalone, PerNode, PerGB2018]` | Required. Service Tier: PerGB2018, Free, Standalone, PerGB or PerNode |
| `storageInsightsConfigs` | array | `[]` |  | Optional. List of storage accounts to be read by the workspace. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `useResourcePermissions` | bool |  |  | Optional. Set to 'true' to use resource or workspace permissions and 'false' (or leave empty) to require workspace permissions. |

### Parameter Usage: `gallerySolutions`

```json
"gallerySolutions": {
    "value": [
        "AgentHealthAssessment",
        "AlertManagement",
        "AntiMalware",
        "AzureActivity",
        //"AzureAppGatewayAnalytics",
        "AzureAutomation",
        "AzureCdnCoreAnalytics",
        "AzureDataFactoryAnalytics",
        "AzureNSGAnalytics",
        "AzureSQLAnalytics",
        "ChangeTracking",
        "Containers",
        "InfrastructureInsights",
        "KeyVaultAnalytics",
        "LogicAppsManagement",
        "NetworkMonitoring",
        "Security",
        "SecurityCenterFree",
        "ServiceFabric",
        "ServiceMap",
        "SQLAssessment",
        "Updates",
        "VMInsights",
        "WireData2",
        "WaaSUpdateInsights"
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
| `logAnalyticsName` | string | The name of the deployed log analytics workspace |
| `logAnalyticsResourceGroup` | string | The resource group of the deployed log analytics workspace |
| `logAnalyticsResourceId` | string | The resource ID of the deployed log analytics workspace |
| `logAnalyticsWorkspaceId` | string | The ID associated with the workspace |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-04-01-preview/roleAssignments)
- [Solutions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions)
- [Workspaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces)
- [Workspaces/Datasources](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources)
- [Workspaces/Linkedservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices)
- [Workspaces/Savedsearches](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches)
- [Workspaces/Storageinsightconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs)

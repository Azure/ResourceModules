# LogAnalytics `[Microsoft.OperationalInsights/workspaces]`

This template deploys Log Analytics.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.OperationalInsights/workspaces` | 2020-08-01 |
| `Microsoft.OperationalInsights/workspaces/dataSources` | 2020-03-01-preview |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2020-03-01-preview |
| `Microsoft.OperationalInsights/workspaces/providers/roleAssignments` | 2021-04-01-preview |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | 2020-03-01-preview |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | 2020-03-01-preview |
| `Microsoft.OperationsManagement/solutions` | 2015-11-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `activityLogAdditionalSubscriptionIDs` | array | `[]` |  | Optional. List of additional Subscription IDs to collect Activity logs from. The subscription holding the Log Analytics workspace is added by default. The user/SPN/managed identity has to have reader access on the subscription you'd like to collect Activity logs from. |
| `automationAccountId` | string |  |  | Optional. Automation Account resource identifier, value used to create a LinkedService between Log Analytics and an Automation Account. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `dailyQuotaGb` | int | `-1` |  | Optional. The workspace daily quota for ingestion. |
| `dataRetention` | int | `365` |  | Required. Number of days data will be retained for |
| `diagnosticStorageAccountId` | string |  |  | Optional. Log Analytics workspace resource identifier |
| `gallerySolutions` | array | `[]` |  | Optional. LAW gallerySolutions from the gallery. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logAnalyticsWorkspaceName` | string |  |  | Required. Name of the Log Analytics workspace |
| `publicNetworkAccessForIngestion` | string | `Enabled` | `[Enabled, Disabled]` | Optional. The network access type for accessing Log Analytics ingestion. |
| `publicNetworkAccessForQuery` | string | `Enabled` | `[Enabled, Disabled]` | Optional. The network access type for accessing Log Analytics query. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `serviceTier` | string | `PerGB2018` | `[Free, Standalone, PerNode, PerGB2018]` | Required. Service Tier: PerGB2018, Free, Standalone, PerGB or PerNode |
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
| `logAnalyticsName` | string |
| `logAnalyticsResourceGroup` | string |
| `logAnalyticsResourceId` | string |
| `logAnalyticsWorkspaceId` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Workspaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces)
- [Workspaces/Datasources](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-03-01-preview/workspaces/dataSources)
- [Workspaces/Linkedservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-03-01-preview/workspaces/linkedServices)
- [Workspaces/Savedsearches](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-03-01-preview/workspaces/savedSearches)
- [Workspaces/Storageinsightconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-03-01-preview/workspaces/storageInsightConfigs)
- [Solutions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions)

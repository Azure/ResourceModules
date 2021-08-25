# LogAnalytics

This template deploys Log Analytics.

## Resource types

|ResourceType|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.OperationalInsights/workspaces`|2017-03-15-preview|
|`Microsoft.OperationalInsights/workspaces/datasources`|2015-11-01-preview|
|`Microsoft.OperationalInsights/workspaces/storageinsightconfigs`|2015-03-20|
|`Microsoft.OperationsManagement/solutions`|2015-11-01-preview|
|`Microsoft.OperationalInsights/workspaces/linkedServices`|2015-11-01-preview|
|`Microsoft.OperationalInsights/workspaces/providers/locks`|2016-09-01|
|`savedSearches`|2017-03-15-preview|
|`datasources`|2015-11-01-preview|
|`Microsoft.OperationalInsights/workspaces/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `activityLogAdditionalSubscriptionIDs` | array | Optional. List of additional Subscription IDs to collect Activity logs from. The subscription holding the Log Analytics workspace is added by default. The user/SPN/managed identity has to have reader access on the subscription you'd like to collect Activity logs from. | System.Object[] |  |
| `automationAccountId` | string | Optional. Automation Account resource identifier, value used to create a LinkedService between Log Analytics and an Automation Account. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `dataRetention` | int | Required. Number of days data will be retained for | 365 |  |
| `dailyQuotaGb` | int | Optional. The workspace daily quota for ingestion. | -1 (i.e. no quota) |  |
| `publicNetworkAccessForIngestion` | string | Optional. The network access type for accessing Log Analytics ingestion. | Enabled | Enabled, Disabled |
| `publicNetworkAccessForQuery` | string | Optional. The network access type for accessing Log Analytics query. | Enabled | Enabled, Disabled |
| `diagnosticStorageAccountId` | string | Optional. Log Analytics workspace resource identifier |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock storage from deletion. | False |  |
| `logAnalyticsWorkspaceName` | string | Required. Name of the Log Analytics workspace |  |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `serviceTier` | string | Required. Service Tier: PerGB2018, Free, Standalone, PerGB or PerNode | PerGB2018 | System.Object[] |
| `solutions` | array | Optional. LAW solutions from the gallery. | [] | "Updates", "AzureAutomation", ... (see below) |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `useResourcePermissions` | bool | Optional. Set to 'true' to use resource or workspace permissions and 'false' (or leave empty) to require workspace permissions. | False | true, false |

### Parameter Usage: `solutions`

```json
"solutions": {
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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `logAnalyticsPrimarySharedKey` | securestring | The Primary Shared Key for Log Analytics. |
| `logAnalyticsWorkspaceId` | string | The Workspace Id for Log Analytics. |
| `logAnalyticsName` | string | The Name of the Log Analytics workspace deployed. |
| `logAnalyticsResourceGroup` | string | The Resource Group log analytics was deployed to. |
| `logAnalyticsResourceId` | string | The Resource Id of the Log Analytics workspace deployed. |

## Considerations

*N/A*

## Additional resources

- [Microsoft.OperationalInsights workspaces template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.operationalinsights/2015-11-01-preview/workspaces)
- [Microsoft.OperationalManagement solutions template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.operationsmanagement/2015-11-01-preview/solutions)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Manage access to log data and workspaces in Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-access)

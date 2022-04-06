# Log Analytics Workspaces `[Microsoft.OperationalInsights/workspaces]`

This template deploys a log analytics workspace.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

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

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Log Analytics workspace |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `dailyQuotaGb` | int | `-1` |  | The workspace daily quota for ingestion. |
| `dataRetention` | int | `365` |  | Number of days data will be retained for |
| `dataSources` | _[dataSources](dataSources/readme.md)_ array | `[]` |  | LAW data sources to configure. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[Audit]` | `[Audit]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of a log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `gallerySolutions` | array | `[]` |  | LAW gallerySolutions from the gallery. |
| `linkedServices` | _[linkedServices](linkedServices/readme.md)_ array | `[]` |  | List of services to be linked. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `publicNetworkAccessForIngestion` | string | `'Enabled'` | `[Enabled, Disabled]` | The network access type for accessing Log Analytics ingestion. |
| `publicNetworkAccessForQuery` | string | `'Enabled'` | `[Enabled, Disabled]` | The network access type for accessing Log Analytics query. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `savedSearches` | _[savedSearches](savedSearches/readme.md)_ array | `[]` |  | Kusto Query Language searches to save. |
| `serviceTier` | string | `'PerGB2018'` | `[Free, Standalone, PerNode, PerGB2018]` | Service Tier: PerGB2018, Free, Standalone, PerGB or PerNode |
| `storageInsightsConfigs` | array | `[]` |  | List of storage accounts to be read by the workspace. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `useResourcePermissions` | bool | `False` |  | Set to 'true' to use resource or workspace permissions and 'false' (or leave empty) to require workspace permissions. |


### Parameter Usage: `gallerySolutions`

```json
"gallerySolutions": {

    "value": [
        {
            "name": "AgentHealthAssessment",
            "product": "OMSGallery/AgentHealthAssessment",
            "publisher": "Microsoft"
        },
        {
            "name": "AlertManagement",
            "product": "OMSGallery/AlertManagement",
            "publisher": "Microsoft"
        },
        {
            "name": "AntiMalware",
            "product": "OMSGallery/AntiMalware",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureActivity",
            "product": "OMSGallery/AzureActivity",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureAutomation",
            "product": "OMSGallery/AzureAutomation",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureCdnCoreAnalytics",
            "product": "OMSGallery/AzureCdnCoreAnalytics",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureDataFactoryAnalytics",
            "product": "OMSGallery/AzureDataFactoryAnalytics",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureNSGAnalytics",
            "product": "OMSGallery/AzureNSGAnalytics",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureSQLAnalytics",
            "product": "OMSGallery/AzureSQLAnalytics",
            "publisher": "Microsoft"
        },
        {
            "name": "ChangeTracking",
            "product": "OMSGallery/ChangeTracking",
            "publisher": "Microsoft"
        },
        {
            "name": "Containers",
            "product": "OMSGallery/Containers",
            "publisher": "Microsoft"
        },
        {
            "name": "InfrastructureInsights",
            "product": "OMSGallery/InfrastructureInsights",
            "publisher": "Microsoft"
        },
        {
            "name": "KeyVaultAnalytics",
            "product": "OMSGallery/KeyVaultAnalytics",
            "publisher": "Microsoft"
        },
        {
            "name": "LogicAppsManagement",
            "product": "OMSGallery/LogicAppsManagement",
            "publisher": "Microsoft"
        },
        {
            "name": "NetworkMonitoring",
            "product": "OMSGallery/NetworkMonitoring",
            "publisher": "Microsoft"
        },
        {
            "name": "Security",
            "product": "OMSGallery/Security",
            "publisher": "Microsoft"
        },
        {
            "name": "SecurityCenterFree",
            "product": "OMSGallery/SecurityCenterFree",
            "publisher": "Microsoft"
        },
        {
            "name": "ServiceFabric",
            "product": "OMSGallery/ServiceFabric",
            "publisher": "Microsoft"
        },
        {
            "name": "ServiceMap",
            "product": "OMSGallery/ServiceMap",
            "publisher": "Microsoft"
        },
        {
            "name": "SQLAssessment",
            "product": "OMSGallery/SQLAssessment",
            "publisher": "Microsoft"
        },
        {
            "name": "Updates",
            "product": "OMSGallery/Updates",
            "publisher": "Microsoft"
        },
        {
            "name": "VMInsights",
            "product": "OMSGallery/VMInsights",
            "publisher": "Microsoft"
        },
        {
            "name": "WireData2",
            "product": "OMSGallery/WireData2",
            "publisher": "Microsoft"
        },
        {
            "name": "WaaSUpdateInsights",
            "product": "OMSGallery/WaaSUpdateInsights",
            "publisher": "Microsoft"
        }
    ]
}
```

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

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
| `logAnalyticsWorkspaceId` | string | The ID associated with the workspace |
| `name` | string | The name of the deployed log analytics workspace |
| `resourceGroupName` | string | The resource group of the deployed log analytics workspace |
| `resourceId` | string | The resource ID of the deployed log analytics workspace |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Solutions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions)
- [Workspaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces)
- [Workspaces/Datasources](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources)
- [Workspaces/Linkedservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices)
- [Workspaces/Savedsearches](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches)
- [Workspaces/Storageinsightconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs)

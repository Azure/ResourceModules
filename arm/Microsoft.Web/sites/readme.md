# Web/Function App

This module deploys a Web or Function App 

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Web/sites/config` | 2019-08-01 |
| `microsoft.Insights/components` | 2018-05-01-preview |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |
| `Microsoft.Network/privateEndpoints` | 2020-05-01 |
| `Microsoft.Resources/deployments` | 2021-01-01 |
| `Microsoft.Web/serverfarms` | 2021-02-01 |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Web/sites/providers/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Web/sites` | 2021-02-01 |
| `Microsoft.Authorization/locks` | 2016-09-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

- *None*

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `appName` | string | Required. Name of the Web Application Portal Name |  |  |
| `appServiceEnvironmentId` | string | Optional. The Resource Id of the App Service Environment to use for the Function App. |  |  |
| `appServicePlanFamily` | string | Optional. SkuFamily of app service plan deployed if no appServicePlanId was provided. |  |  |
| `appServicePlanId` | string | Optional. The Resource Id of the App Service Plan to use for the App. If not provided, the hosting plan name is used to create a new plan. |  |  |
| `appServicePlanName` | string | Optional. Required if no appServicePlanId is provided to deploy a new app service plan. |  |  |
| `appServicePlanSize` | string | Optional. SkuSize of app service plan deployed if no appServicePlanId was provided. |  |  |
| `appServicePlanSkuName` | string | Optional. The pricing tier for the hosting plan. | F1 | System.Object[] |
| `appServicePlanTier` | string | Optional. SkuTier of app service plan deployed if no appServicePlanId was provided. |  |  |
| `appServicePlanType` | string | Optional. SkuType of app service plan deployed if no appServicePlanId was provided. | linux | System.Object[] |
| `appServicePlanWorkerSize` | int | Optional. Defines the number of workers from the worker pool that will be used by the app service plan | 2 |  |
| `appType` | string | Required. Type of site to deploy |  | System.Object[] |
| `clientAffinityEnabled` | bool | Optional. If Client Affinity is enabled. | True |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `enableMonitoring` | bool | Optional. If true, ApplicationInsights will be configured for the Function App. | True |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `functionsExtensionVersion` | string | Optional. Version if the function extension. | ~3 |  |
| `functionsWorkerRuntime` | string | Optional. Runtime of the function worker. |  | System.Object[] |
| `httpsOnly` | bool | Optional. Configures a web site to accept only https requests. Issues redirect for http requests. | True |  |
| `location` | string | Optional. Location for all Resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Key Vault from deletion. | False |  |
| `managedServiceIdentity` | string | Optional. Type of managed service identity. | None | System.Object[] |
| `privateEndpoints` | array | Optional. Configuration Details for private endpoints. | System.Object[] |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `siteConfig` | object | Required. Configuration of the app. |  |  |
| `storageAccountName` | string | Optional. The name of the storage account to managing triggers and logging function executions. |  |  |
| `storageAccountResourceGroupName` | string | Optional. Resource group of the storage account to use. Required if the storage account is in a different resource group than the function app itself. | [resourceGroup().name] |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `userAssignedIdentities` | object | Optional. Mandatory 'managedServiceIdentity' contains UserAssigned. The identy to assign to the resource. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |

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
| `siteName` | string | The Name of the Application Web Services |
| `siteResourceGroup` | string | The name of the Resource Group with the Application Web Services |
| `siteResourceId` | string | The Resource Id of the Application Web Services |

## Considerations

- *None*

## Additional resources

- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Azure Resource Manager template reference](https://docs.microsoft.com/en-us/azure/templates/)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [Serverfarms](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2019-08-01/serverfarms)
- [Sites](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2019-08-01/sites)
- [Components](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/2018-05-01-preview/components)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-01-01/deployments)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
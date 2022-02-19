# Data Factories `[Microsoft.DataFactory/factories]`

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.DataFactory/factories` | 2018-06-01 |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 |
| `Microsoft.DataFactory/factories/managedVirtualNetworks` | 2018-06-01 |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. |
| `gitAccountName` | string |  |  | Optional. The account name. |
| `gitCollaborationBranch` | string | `main` |  | Optional. The collaboration branch name. Default is 'main'. |
| `gitConfigureLater` | bool | `True` |  | Optional. Boolean to define whether or not to configure git during template deployment. |
| `gitProjectName` | string |  |  | Optional. The project name. Only relevant for 'FactoryVSTSConfiguration'. |
| `gitRepositoryName` | string |  |  | Optional. The repository name. |
| `gitRepoType` | string | `FactoryVSTSConfiguration` |  | Optional. Repository type - can be 'FactoryVSTSConfiguration' or 'FactoryGitHubConfiguration'. Default is 'FactoryVSTSConfiguration'. |
| `gitRootFolder` | string | `/` |  | Optional. The root folder path name. Default is '/'. |
| `integrationRuntime` | _[integrationRuntime](integrationRuntime/readme.md)_ object | `{object}` |  | Optional. The object for the configuration of a Integration Runtime |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all Resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[ActivityRuns, PipelineRuns, TriggerRuns, SSISPackageEventMessages, SSISPackageExecutableStatistics, SSISPackageEventMessageContext, SSISPackageExecutionComponentPhases, SSISPackageExecutionDataStatistics, SSISIntegrationRuntimeLogs]` | `[ActivityRuns, PipelineRuns, TriggerRuns, SSISPackageEventMessages, SSISPackageExecutableStatistics, SSISPackageEventMessageContext, SSISPackageExecutionComponentPhases, SSISPackageExecutionDataStatistics, SSISIntegrationRuntimeLogs]` | Optional. The name of logs that will be streamed. |
| `managedVirtualNetworkName` | string |  |  | Optional. The name of the Managed Virtual Network |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. The name of the Azure Factory to create |
| `publicNetworkAccess` | bool | `True` |  | Optional. Enable or disable public network access. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `systemAssignedIdentity` | bool |  |  | Optional. Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |

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

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
},
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The Name of the Azure Data Factory instance. |
| `resourceGroupName` | string | The name of the Resource Group with the Data factory. |
| `resourceId` | string | The Resource ID of the Data factory. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Factories](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories)
- [Factories/Integrationruntimes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes)
- [Factories/Managedvirtualnetworks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

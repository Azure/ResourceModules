# DataFactory `[Microsoft.DataFactory/factories]`

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.DataFactory/factories` | 2018-06-01 |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 |
| `Microsoft.DataFactory/factories/managedVirtualNetworks` | 2018-06-01 |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `dataFactoryName` | string |  |  | Required. The name of the Azure Factory to create |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `gitAccountName` | string |  |  | Optional. The account name. |
| `gitCollaborationBranch` | string | `main` |  | Optional. The collaboration branch name. Default is 'main'. |
| `gitConfigureLater` | bool | `True` |  | Optional. Boolean to define whether or not to configure git during template deployment. |
| `gitProjectName` | string |  |  | Optional. The project name. Only relevant for 'FactoryVSTSConfiguration'. |
| `gitRepositoryName` | string |  |  | Optional. The repository name. |
| `gitRepoType` | string | `FactoryVSTSConfiguration` |  | Optional. Repo type - can be 'FactoryVSTSConfiguration' or 'FactoryGitHubConfiguration'. Default is 'FactoryVSTSConfiguration'. |
| `gitRootFolder` | string | `/` |  | Optional. The root folder path name. Default is '/'. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all Resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[ActivityRuns, PipelineRuns, TriggerRuns, SSISPackageEventMessages, SSISPackageExecutableStatistics, SSISPackageEventMessageContext, SSISPackageExecutionComponentPhases, SSISPackageExecutionDataStatistics, SSISIntegrationRuntimeLogs]` | `[ActivityRuns, PipelineRuns, TriggerRuns, SSISPackageEventMessages, SSISPackageExecutableStatistics, SSISPackageEventMessageContext, SSISPackageExecutionComponentPhases, SSISPackageExecutionDataStatistics, SSISIntegrationRuntimeLogs]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `publicNetworkAccess` | bool | `True` |  | Optional. Enable or disable public network access. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Contributor",
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
| `dataFactoryName` | string | The Name of the Azure Data Factory instance. |
| `dataFactoryResourceGroup` | string | The name of the Resource Group with the Data factory. |
| `dataFactoryResourceId` | string | The Resource Id of the Data factory. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Factories](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories)
- [Factories/Integrationruntimes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes)
- [Factories/Managedvirtualnetworks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)

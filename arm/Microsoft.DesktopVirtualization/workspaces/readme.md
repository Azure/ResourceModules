# WVD Workspaces

This module deploys WVD Workspaces, with resource lock and diagnostic configuration.



## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.DesktopVirtualization/workspaces`|2019-12-10-preview|
|`Microsoft.DesktopVirtualization/workspaces/providers/diagnosticsettings`|2017-05-01-preview|
|`Microsoft.Resources/deployments`|2018-02-01|
|`providers/locks`|2016-09-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `appGroupResourceIds` | array | Required. Resource IDs fo the existing Application groups this workspace will group together. | System.Object[] |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Resource from deletion. | False |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `workspaceDescription` | string | Optional. The description of the Workspace to be created. |  |  |
| `workspaceFriendlyName` | string | Optional. The friendly name of the Workspace to be created. |  | |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |
| `workSpaceName` | String | Required. The name of the workspace to be attach to new Application Group. |  |  |

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
| `workspaceName` | string | The Name of the Workspace. |
| `workspaceResourceGroup` | string | The name of the Resource Group the WVD Workspace was created in. |
| `workspaceResourceId` | string | The Resource Id of the WVD Workspace. |

## Considerations

*N/A*

## Additional resources

- [What is Windows Virtual Desktop?](https://docs.microsoft.com/en-us/azure/virtual-desktop/overview)
- [Windows Virtual Desktop environment](https://docs.microsoft.com/en-us/azure/virtual-desktop/environment-setup)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
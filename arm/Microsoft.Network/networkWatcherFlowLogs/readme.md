# NSG Flow Logs

This module controls the Network Security Group Flow Logs and analytics settings
**Note: this module must be run on the Resource Group where Network Watcher is deployed**

## Resource types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Network/networkWatchers/flowLogs`|2019-11-01|
|`Microsoft.Resources/deployments`|2020-06-01|

## Parameters

| Parameter Name                   | Type   | Default Value                | Possible values               | Description                                                  |
| :------------------------------- | :----- | :--------------------------- | :---------------------------- | :----------------------------------------------------------- |
| `networkWatcherName`             | string |                              |                               | Required. The name of the Network Watcher in the same region as the NSG. |
| `networkSecurityGroupResourceId` | string |                              |                               | Required. The Resource ID of the NSG that FlowLog must be configured |
| `diagnosticStorageAccountId`     | string |                              |                               | Required. Resource ID of the storage account which is used to store the flow log. |
| `location`                       | string | `[resourceGroup().location]` | Azure Regions                 | Optional. Must be the same location as the NSG.              |
| `tags`                           | object | {}                           | Complex structure, see below. | Optional. Tags of the FlowLog resource.                      |
| `retentionEnabled`               | bool   | true                         | true, false                   | Optional. Flag to enable/disable retention. Storage v2 must be specified if enabled. |
| `flowLogEnabled`                 | bool   | true                         | true, false                   | Optional. Flag to enable/disable flow logging.               |
| `logFormatVersion`               | int    | 2                            | 1, 2                          | Optional. The version (revision) of the flow log.            |
| `flowAnalyticsEnabled`           | bool   | false                         | true, false                   | Optional. Flag to enable/disable traffic analytics.          |
| `workspaceResourceId`            | string | ""                           |                               | Optional. Resource Id of the attached Log Analytics. is Mandatory if flowAnalyticsEnabled=true or flowLogs has ever been enabled |
| `flowLogIntervalInMinutes`       | int    | 60                           | 10, 60                        | Optional. The interval in minutes which would decide how frequently TA service should do flow analytics |
| `retentionInDays`                | int    | 365                          | 0..365                        | Optional. Number of days to retain flow log records.         |
| `cuaId` | string |  |  |  Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |

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
| `deploymentResourceGroup` | string | The name of the Resource Group the Network Security Groups were created in. |
| `flowLogName` | string | The Name of the FlowLog deployed. |
| `flowLogResourceId` | string | The Resource Ids of the Network Security Group deployed. |

## Considerations

If Flow Logs traffic analytic has ever been enabled for the considered Network Security Group, even when disabling it WorkspaceResourceId must be specified targeting an existing Log Analytics workspace.<br>
If no Log Analytics Workspace exists or you don't want it to remain stored in the Flow Log configuration, delete the Flow Log resource

## Additional resources

- [Azure Flow Logs](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-overview)
- [Microsoft.Network networkWatchers/flowLogs template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-11-01/networkwatchers/flowlogs)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
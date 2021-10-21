# NSG Flow Logs `[Microsoft.Network/networkWatcherFlowLogs]`

This module controls the Network Security Group Flow Logs and analytics settings
**Note: this module must be run on the Resource Group where Network Watcher is deployed**

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Network/networkWatchers/flowLogs` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `diagnosticStorageAccountId` | string |  |  | Required. Resource identifier of the Diagnostic Storage Account. |
| `flowAnalyticsEnabled` | bool |  |  | Optional. Enables/disables flow analytics. If Flow Analytics was previously enabled, workspaceResourceID is mandatory (even when disabling it) |
| `flowLogEnabled` | bool | `True` |  | Optional. If the flow log should be enabled |
| `flowLogIntervalInMinutes` | int | `60` | `[10, 60]` | Optional. The interval in minutes which would decide how frequently TA service should do flow analytics. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `logFormatVersion` | int | `2` | `[1, 2]` | Optional. The flow log format version |
| `networkSecurityGroupResourceId` | string |  |  | Required. Resource ID of the NSG that must be enabled for Flow Logs. |
| `networkWatcherName` | string |  |  | Required. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG |
| `retentionEnabled` | bool | `True` |  | Optional. If the flow log retention should be enabled |
| `retentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `workspaceResourceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

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
| `deploymentResourceGroup` | string |
| `flowLogName` | string |
| `flowLogResourceId` | string |

## Template references

- [Networkwatchers/Flowlogs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/networkWatchers/flowLogs)

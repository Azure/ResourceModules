# NetworkNetworkwatchersConnectionmonitors `[Microsoft.Network/networkWatchers/connectionMonitors]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Network/networkWatchers/connectionMonitors` | 2021-03-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `destinationAddress` | string |  |  | Optional.	Address of the connection monitor destination (IP or domain name). |
| `destinationPort` | int | `80` |  | Optional.	The destination port used by connection monitor. |
| `destinationResourceId` | string |  |  | Optional. The ID of the resource used as the destination by connection monitor. |
| `endpoints` | array | `[]` |  | Optional. List of connection monitor endpoints. |
| `monitoringInterval` | int | `30` |  | Optional.	Monitoring interval in seconds. |
| `name` | string |  |  | Optional. Name of the resource. |
| `networkWatcherName` | string | `[format('NetworkWatcher_{0}', resourceGroup().location)]` |  | Optional. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG |
| `notes` | string |  |  | Optional.	The ID of the resource used as the source by connection monitor. |
| `sourcePort` | int | `80` |  | Optional.	The source port used by connection monitor. |
| `sourceResourceId` | string |  |  | Required.	The ID of the resource used as the source by connection monitor. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `testConfigurations` | array | `[]` |  | Optional. List of connection monitor test configurations. |
| `testGroups` | array | `[]` |  | Optional.	List of connection monitor test groups. |
| `workspaceResourceId` | string |  |  | Optional. Specify the Log Analytics Workspace Resource ID |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `connectionMonitorName` | string | The name of the deployed connection monitor |
| `connectionMonitorResourceGroup` | string | The resource group the connection monitor was deployed into |
| `connectionMonitorResourceId` | string | The resourceId of the deployed connection monitor |

## Template references

- [Networkwatchers/Connectionmonitors](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/networkWatchers/connectionMonitors)

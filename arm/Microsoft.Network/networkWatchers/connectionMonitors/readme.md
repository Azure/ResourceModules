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
| `endpoints` | array | `[]` |  | Optional. List of connection monitor endpoints. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `name` | string |  |  | Optional. Name of the resource. |
| `networkWatcherName` | string | `[format('NetworkWatcher_{0}', resourceGroup().location)]` |  | Optional. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG |
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

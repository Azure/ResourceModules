# OperationalinsightsWorkspacesDatasources `[Microsoft.OperationalInsights/workspaces/dataSources]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/dataSources` | 2020-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `counterName` | string |  |  | Optional. Counter name to configure when kind is WindowsPerformanceCounter. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `eventLogName` | string |  |  | Optional. Windows event log name to configure when kind is WindowsEvent. |
| `eventTypes` | array | `[]` |  | Optional. Windows event types to configure when kind is WindowsEvent. |
| `instanceName` | string | `*` |  | Optional. Name of the instance to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| `intervalSeconds` | int | `60` |  | Optional. Interval in seconds to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| `kind` | string | `AzureActivityLog` | `[AzureActivityLog, WindowsEvent, WindowsPerformanceCounter, IISLogs, LinuxSyslog, LinuxSyslogCollection, LinuxPerformanceObject, LinuxPerformanceCollection]` | Required. The kind of the DataSource. |
| `linkedResourceId` | string |  |  | Optional. Id of the resource to be linked. |
| `logAnalyticsWorkspaceName` | string |  |  | Required. Name of the Log Analytics workspace |
| `name` | string |  |  | Required. Name of the solution |
| `objectName` | string |  |  | Optional. Name of the object to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| `performanceCounters` | array | `[]` |  | Optional. List of counters to configure when the kind is LinuxPerformanceObject. |
| `state` | string |  |  | Optional. State to configure when kind is IISLogs or LinuxSyslogCollection or LinuxPerformanceCollection. |
| `syslogName` | string |  |  | Optional. System log to configure when kind is LinuxSyslog. |
| `syslogSeverities` | array | `[]` |  | Optional. Severities to configure when kind is LinuxSyslog. |
| `tags` | object | `{object}` |  | Optional. Tags to configure in the resource. |

## Outputs

| Output Name | Type |
| :-- | :-- |

## Template references

- [Workspaces/Datasources](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources)

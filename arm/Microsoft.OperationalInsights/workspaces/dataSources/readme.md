# Operationalinsights Workspaces Datasources `[Microsoft.OperationalInsights/workspaces/dataSources]`

This template deploys a data source for a Log Analytics workspace.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/dataSources` | 2020-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `counterName` | string |  |  | Optional. Counter name to configure when kind is WindowsPerformanceCounter. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `eventLogName` | string |  |  | Optional. Windows event log name to configure when kind is WindowsEvent. |
| `eventTypes` | array | `[]` |  | Optional. Windows event types to configure when kind is WindowsEvent. |
| `instanceName` | string | `*` |  | Optional. Name of the instance to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| `intervalSeconds` | int | `60` |  | Optional. Interval in seconds to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| `kind` | string | `AzureActivityLog` | `[AzureActivityLog, WindowsEvent, WindowsPerformanceCounter, IISLogs, LinuxSyslog, LinuxSyslogCollection, LinuxPerformanceObject, LinuxPerformanceCollection]` | Required. The kind of the DataSource. |
| `linkedResourceId` | string |  |  | Optional. Resource ID of the resource to be linked. |
| `logAnalyticsWorkspaceName` | string |  |  | Required. Name of the Log Analytics workspace |
| `name` | string |  |  | Required. Name of the solution |
| `objectName` | string |  |  | Optional. Name of the object to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| `performanceCounters` | array | `[]` |  | Optional. List of counters to configure when the kind is LinuxPerformanceObject. |
| `state` | string |  |  | Optional. State to configure when kind is IISLogs or LinuxSyslogCollection or LinuxPerformanceCollection. |
| `syslogName` | string |  |  | Optional. System log to configure when kind is LinuxSyslog. |
| `syslogSeverities` | array | `[]` |  | Optional. Severities to configure when kind is LinuxSyslog. |
| `tags` | object | `{object}` |  | Optional. Tags to configure in the resource. |

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
| `dataSourceName` | string | The name of the deployed data source |
| `dataSourceResourceGroup` | string | The resource group where the data source is deployed |
| `dataSourceResourceId` | string | The resource ID of the deployed data source |

## Template references

- [Workspaces/Datasources](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources)

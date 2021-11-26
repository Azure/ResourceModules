# WebSitesConfig `[Microsoft.Web/sites/config]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Web/sites/config` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appInsightId` | string |  |  | Optional. The Resource ID of the App Insight to leverage for the App. |
| `appName` | string |  |  | Required. Name of the Web Application Portal Name |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `functionsExtensionVersion` | string | `~3` |  | Optional. Version of the function extension. |
| `functionsWorkerRuntime` | string |  | `[dotnet, node, python, java, powershell, ]` | Optional. Runtime of the function worker. |
| `name` | string |  | `[appsettings]` | Required. Name of the Web Application Portal config name |
| `storageAccountId` | string |  |  | Optional. Required if app of kind functionapp. The resource ID of the storage account to manage triggers and logging function executions. |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `configName` | string | The name of the web sites config |
| `configResourceGroup` | string | The resource group the web sites config was deployed into |
| `configResourceId` | string | The resourceId of the web sites config |

## Template references

- [Sites/Config](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-02-01/sites/config)

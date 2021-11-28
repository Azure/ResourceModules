# Web Site Config `[Microsoft.Web/sites/config]`

This module deploys a site config resource.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/config` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appInsightId` | string |  |  | Optional. Resource ID of the app insight to leverage for this resource. |
| `appName` | string |  |  | Required. Name of the site parent resource. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. |
| `functionsExtensionVersion` | string | `~3` |  | Optional. Version of the function extension. |
| `functionsWorkerRuntime` | string |  | `[dotnet, node, python, java, powershell, ]` | Optional. Runtime of the function worker. |
| `name` | string |  | `[appsettings]` | Required. Name of the site config. |
| `storageAccountId` | string |  |  | Optional. Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `configName` | string | The name of the site config. |
| `configResourceGroup` | string | The resource group the site config was deployed into. |
| `configResourceId` | string | The resource ID of the site config. |

## Template references

- [Sites/Config](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-02-01/sites/config)

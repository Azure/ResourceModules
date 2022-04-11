# Web Site Config `[Microsoft.Web/sites/config]`

This module deploys a site config resource.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/config` | 2021-02-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `appName` | string |  | Name of the site parent resource. |
| `name` | string | `[appsettings]` | Name of the site config. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appInsightId` | string | `''` |  | Resource ID of the app insight to leverage for this resource. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `functionsExtensionVersion` | string | `'~3'` |  | Version of the function extension. |
| `functionsWorkerRuntime` | string | `''` | `[dotnet, node, python, java, powershell, ]` | Runtime of the function worker. |
| `storageAccountId` | string | `''` |  | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the site config. |
| `resourceGroupName` | string | The resource group the site config was deployed into. |
| `resourceId` | string | The resource ID of the site config. |

## Template references

- ['sites/config' Parent Documentation](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/sites)

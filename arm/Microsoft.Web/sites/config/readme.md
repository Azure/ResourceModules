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
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appName` | string |  |  | Name of the site parent resource. |
| `name` | string | `'appsettings'` | `[appsettings]` | Name of the site config. |

**Conditional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `storageAccountId` | string | `''` | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. If provided, the `AzureWebJobsStorage` setting is added to the app's app settings. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `appInsightId` | string | `''` | Resource ID of the app insight to leverage for this resource. If provided, both the `APPINSIGHTS_INSTRUMENTATIONKEY` & `APPLICATIONINSIGHTS_CONNECTION_STRING` setting are added to the app's app settings. |
| `customAppSettings` | object | `{object}` | Custom app settings to apply to the app |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |


### Parameter Usage: `customAppSettings`

Using this parameter you can inject custom app settings into the app.

```json
"customAppSettings": {
    "value": {
        "FUNCTIONS_EXTENSION_VERSION": "~3",
        "FUNCTIONS_WORKER_RUNTIME": "powershell"
    }
}
```


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the site config. |
| `resourceGroupName` | string | The resource group the site config was deployed into. |
| `resourceId` | string | The resource ID of the site config. |

## Template references

- ['sites/config' Parent Documentation](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/sites)

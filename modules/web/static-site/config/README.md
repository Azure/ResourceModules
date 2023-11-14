# Static Web App Site Config `[Microsoft.Web/staticSites/config]`

This module deploys a Static Web App Site Config.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/staticSites/config` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/staticSites/config) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | Type of settings to apply. |
| [`properties`](#parameter-properties) | object | App settings. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`staticSiteName`](#parameter-staticsitename) | string | The name of the parent Static Web App. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `kind`

Type of settings to apply.
- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'appsettings'
    'functionappsettings'
  ]
  ```

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `properties`

App settings.
- Required: Yes
- Type: object

### Parameter: `staticSiteName`

The name of the parent Static Web App. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the config. |
| `resourceGroupName` | string | The name of the resource group the config was created in. |
| `resourceId` | string | The resource ID of the config. |

## Cross-referenced modules

_None_

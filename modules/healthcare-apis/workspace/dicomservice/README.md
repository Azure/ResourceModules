# Healthcare API Workspace DICOM Services `[Microsoft.HealthcareApis/workspaces/dicomservices]`

This module deploys a Healthcare API Workspace DICOM Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.HealthcareApis/workspaces/dicomservices` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/workspaces) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the DICOM service. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent health data services workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`corsAllowCredentials`](#parameter-corsallowcredentials) | bool | Use this setting to indicate that cookies should be included in CORS requests. |
| [`corsHeaders`](#parameter-corsheaders) | array | Specify HTTP headers which can be used during the request. Use "*" for any header. |
| [`corsMaxAge`](#parameter-corsmaxage) | int | Specify how long a result from a request can be cached in seconds. Example: 600 means 10 minutes. |
| [`corsMethods`](#parameter-corsmethods) | array | Specify the allowed HTTP methods. |
| [`corsOrigins`](#parameter-corsorigins) | array | Specify URLs of origin sites that can access this API, or use "*" to allow access from any site. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Control permission for data plane traffic coming from public networks while private endpoint is enabled. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |

### Parameter: `corsAllowCredentials`

Use this setting to indicate that cookies should be included in CORS requests.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `corsHeaders`

Specify HTTP headers which can be used during the request. Use "*" for any header.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `corsMaxAge`

Specify how long a result from a request can be cached in seconds. Example: 600 means 10 minutes.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `corsMethods`

Specify the allowed HTTP methods.
- Required: No
- Type: array
- Default: `[]`
- Allowed: `[DELETE, GET, OPTIONS, PATCH, POST, PUT]`

### Parameter: `corsOrigins`

Specify URLs of origin sites that can access this API, or use "*" to allow access from any site.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed.
- Required: No
- Type: array
- Default: `[AuditLogs]`
- Allowed: `[AuditLogs]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

The name of the DICOM service.
- Required: Yes
- Type: string

### Parameter: `publicNetworkAccess`

Control permission for data plane traffic coming from public networks while private endpoint is enabled.
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workspaceName`

The name of the parent health data services workspace. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the dicom service. |
| `resourceGroupName` | string | The resource group where the namespace is deployed. |
| `resourceId` | string | The resource ID of the dicom service. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_

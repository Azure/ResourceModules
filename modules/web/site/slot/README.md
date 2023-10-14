# Web/Function App Deployment Slots `[Microsoft.Web/sites/slots]`

This module deploys a Web or Function App Deployment Slot.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Web/sites/slots` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots) |
| `Microsoft.Web/sites/slots/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots/hybridConnectionNamespaces/relays) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `kind` | string | `[app, functionapp, functionapp,linux, functionapp,workflowapp, functionapp,workflowapp,linux]` | Type of slot to deploy. |
| `name` | string |  | Name of the slot. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `appName` | string | The name of the parent site resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appInsightResourceId` | string | `''` |  | Resource ID of the app insight to leverage for this resource. |
| `appServiceEnvironmentResourceId` | string | `''` |  | The resource ID of the app service environment to use for this resource. |
| `appSettingsKeyValuePairs` | object | `{object}` |  | The app settings-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING. |
| `authSettingV2Configuration` | object | `{object}` |  | The auth settings V2 configuration. |
| `clientAffinityEnabled` | bool | `True` |  | If client affinity is enabled. |
| `clientCertEnabled` | bool | `False` |  | To enable client certificate authentication (TLS mutual authentication). |
| `clientCertExclusionPaths` | string | `''` |  | Client certificate authentication comma-separated exclusion paths. |
| `clientCertMode` | string | `'Optional'` | `[Optional, OptionalInteractiveUser, Required]` | This composes with ClientCertEnabled setting.</p>- ClientCertEnabled: false means ClientCert is ignored.</p>- ClientCertEnabled: true and ClientCertMode: Required means ClientCert is required.</p>- ClientCertEnabled: true and ClientCertMode: Optional means ClientCert is optional or accepted. |
| `cloningInfo` | object | `{object}` |  | If specified during app creation, the app is cloned from a source app. |
| `containerSize` | int | `-1` |  | Size of the function container. |
| `customDomainVerificationId` | string | `''` |  | Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification. |
| `dailyMemoryTimeQuota` | int | `-1` |  | Maximum allowed daily memory-time quota (applicable on dynamic apps only). |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[if(equals(parameters('kind'), 'functionapp'), createArray('FunctionAppLogs'), createArray('AppServiceHTTPLogs', 'AppServiceConsoleLogs', 'AppServiceAppLogs', 'AppServiceAuditLogs', 'AppServiceIPSecAuditLogs', 'AppServicePlatformLogs'))]` | `[AppServiceAppLogs, AppServiceAuditLogs, AppServiceConsoleLogs, AppServiceHTTPLogs, AppServiceIPSecAuditLogs, AppServicePlatformLogs, FunctionAppLogs]` | The name of logs that will be streamed. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of log analytics workspace. |
| `enabled` | bool | `True` |  | Setting this value to false disables the app (takes the app offline). |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `hostNameSslStates` | array | `[]` |  | Hostname SSL states are used to manage the SSL bindings for app's hostnames. |
| `httpsOnly` | bool | `True` |  | Configures a slot to accept only HTTPS requests. Issues redirect for HTTP requests. |
| `hybridConnectionRelays` | array | `[]` |  | Names of hybrid connection relays to connect app with. |
| `hyperV` | bool | `False` |  | Hyper-V sandbox. |
| `keyVaultAccessIdentityResourceId` | string | `''` |  | The resource ID of the assigned identity to be used to access a key vault with. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. |
| `publicNetworkAccess` | string | `''` | `['', Disabled, Enabled]` | Allow or block all public traffic. |
| `redundancyMode` | string | `'None'` | `[ActiveActive, Failover, GeoRedundant, Manual, None]` | Site redundancy mode. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `serverFarmResourceId` | string | `''` |  | The resource ID of the app service plan to use for the slot. |
| `setAzureWebJobsDashboard` | bool | `[if(contains(parameters('kind'), 'functionapp'), true(), false())]` |  | For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons. |
| `siteConfig` | object | `{object}` |  | The site config object. |
| `storageAccountRequired` | bool | `False` |  | Checks if Customer provided storage account is required. |
| `storageAccountResourceId` | string | `''` |  | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `virtualNetworkSubnetId` | string | `''` |  | Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}. |
| `vnetContentShareEnabled` | bool | `False` |  | To enable accessing content over virtual network. |
| `vnetImagePullEnabled` | bool | `False` |  | To enable pulling image over Virtual Network. |
| `vnetRouteAllEnabled` | bool | `False` |  | Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the slot. |
| `resourceGroupName` | string | The resource group the slot was deployed into. |
| `resourceId` | string | The resource ID of the slot. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/private-endpoint` | Local reference |

## Notes

### Parameter Usage: `appSettingsKeyValuePairs`

AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING are set separately (check parameters storageAccountId, setAzureWebJobsDashboard, appInsightId).
For all other app settings key-value pairs use this object.

<details>

<summary>Parameter JSON format</summary>

```json
"appSettingsKeyValuePairs": {
    "value": {
      "AzureFunctionsJobHost__logging__logLevel__default": "Trace",
      "EASYAUTH_SECRET": "https://adp-[[namePrefix]]-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password",
      "FUNCTIONS_EXTENSION_VERSION": "~4",
      "FUNCTIONS_WORKER_RUNTIME": "dotnet"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
appSettingsKeyValuePairs: {
  AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
  EASYAUTH_SECRET: 'https://adp-[[namePrefix]]-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password'
  FUNCTIONS_EXTENSION_VERSION: '~4'
  FUNCTIONS_WORKER_RUNTIME: 'dotnet'
}
```

</details>
<p>

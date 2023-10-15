# App Service Environments `[Microsoft.Web/hostingEnvironments]`

This module deploys an App Service Environment.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Web/hostingEnvironments` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/hostingEnvironments) |
| `Microsoft.Web/hostingEnvironments/configurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/hostingEnvironments/configurations) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/web.hosting-environment:1.0.0`.

- [Asev2](#example-1-asev2)
- [Asev3](#example-2-asev3)

### Example 1: _Asev2_

<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br:bicep/modules/web.hosting-environment:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-whasev2'
  params: {
    // Required parameters
    name: 'whasev2001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    clusterSettings: [
      {
        name: 'DisableTls1.0'
        value: '1'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    ipsslAddressCount: 2
    kind: 'ASEv2'
    location: '<location>'
    lock: 'CanNotDelete'
    multiSize: 'Standard_D1_V2'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: true
    tags: {
      'hidden-title': 'This is visible in the resource name'
      hostingEnvironmentName: 'whasev2001'
      resourceType: 'App Service Environment'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "whasev2001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "clusterSettings": {
      "value": [
        {
          "name": "DisableTls1.0",
          "value": "1"
        }
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "ipsslAddressCount": {
      "value": 2
    },
    "kind": {
      "value": "ASEv2"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "multiSize": {
      "value": "Standard_D1_V2"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "hostingEnvironmentName": "whasev2001",
        "resourceType": "App Service Environment"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Asev3_

<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br:bicep/modules/web.hosting-environment:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-whasev3'
  params: {
    // Required parameters
    name: 'whasev3001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    allowNewPrivateEndpointConnections: true
    clusterSettings: [
      {
        name: 'DisableTls1.0'
        value: '1'
      }
    ]
    customDnsSuffix: 'internal.contoso.com'
    customDnsSuffixCertificateUrl: '<customDnsSuffixCertificateUrl>'
    customDnsSuffixKeyVaultReferenceIdentity: '<customDnsSuffixKeyVaultReferenceIdentity>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    ftpEnabled: true
    inboundIpAddressOverride: '10.0.0.10'
    internalLoadBalancingMode: 'Web Publishing'
    location: '<location>'
    lock: 'CanNotDelete'
    remoteDebugEnabled: true
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: true
    tags: {
      'hidden-title': 'This is visible in the resource name'
      hostingEnvironmentName: 'whasev3001'
      resourceType: 'App Service Environment'
    }
    upgradePreference: 'Late'
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "whasev3001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "allowNewPrivateEndpointConnections": {
      "value": true
    },
    "clusterSettings": {
      "value": [
        {
          "name": "DisableTls1.0",
          "value": "1"
        }
      ]
    },
    "customDnsSuffix": {
      "value": "internal.contoso.com"
    },
    "customDnsSuffixCertificateUrl": {
      "value": "<customDnsSuffixCertificateUrl>"
    },
    "customDnsSuffixKeyVaultReferenceIdentity": {
      "value": "<customDnsSuffixKeyVaultReferenceIdentity>"
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "ftpEnabled": {
      "value": true
    },
    "inboundIpAddressOverride": {
      "value": "10.0.0.10"
    },
    "internalLoadBalancingMode": {
      "value": "Web, Publishing"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "remoteDebugEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "hostingEnvironmentName": "whasev3001",
        "resourceType": "App Service Environment"
      }
    },
    "upgradePreference": {
      "value": "Late"
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the App Service Environment. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | ResourceId for the subnet. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customDnsSuffixCertificateUrl`](#parameter-customdnssuffixcertificateurl) | string | The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix. Required if customDnsSuffix is not empty. Cannot be used when kind is set to ASEv2. |
| [`customDnsSuffixKeyVaultReferenceIdentity`](#parameter-customdnssuffixkeyvaultreferenceidentity) | string | The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available. Required if customDnsSuffix is not empty. Cannot be used when kind is set to ASEv2. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowNewPrivateEndpointConnections`](#parameter-allownewprivateendpointconnections) | bool | Property to enable and disable new private endpoint connection creation on ASE. Ignored when kind is set to ASEv2. |
| [`clusterSettings`](#parameter-clustersettings) | array | Custom settings for changing the behavior of the App Service Environment. |
| [`customDnsSuffix`](#parameter-customdnssuffix) | string | Enable the default custom domain suffix to use for all sites deployed on the ASE. If provided, then customDnsSuffixCertificateUrl and customDnsSuffixKeyVaultReferenceIdentity are required. Cannot be used when kind is set to ASEv2. |
| [`dedicatedHostCount`](#parameter-dedicatedhostcount) | int | The Dedicated Host Count. If `zoneRedundant` is false, and you want physical hardware isolation enabled, set to 2. Otherwise 0. Cannot be used when kind is set to ASEv2. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`dnsSuffix`](#parameter-dnssuffix) | string | DNS suffix of the App Service Environment. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`frontEndScaleFactor`](#parameter-frontendscalefactor) | int | Scale factor for frontends. |
| [`ftpEnabled`](#parameter-ftpenabled) | bool | Property to enable and disable FTP on ASEV3. Ignored when kind is set to ASEv2. |
| [`inboundIpAddressOverride`](#parameter-inboundipaddressoverride) | string | Customer provided Inbound IP Address. Only able to be set on Ase create. Ignored when kind is set to ASEv2. |
| [`internalLoadBalancingMode`](#parameter-internalloadbalancingmode) | string | Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing. "None" Exposes the ASE-hosted apps on an internet-accessible IP address. |
| [`ipsslAddressCount`](#parameter-ipssladdresscount) | int | Number of IP SSL addresses reserved for the App Service Environment. Cannot be used when kind is set to ASEv3. |
| [`kind`](#parameter-kind) | string | Kind of resource. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`multiSize`](#parameter-multisize) | string | Frontend VM size. Cannot be used when kind is set to ASEv3. |
| [`remoteDebugEnabled`](#parameter-remotedebugenabled) | bool | Property to enable and disable Remote Debug on ASEv3. Ignored when kind is set to ASEv2. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`upgradePreference`](#parameter-upgradepreference) | string | Specify preference for when and how the planned maintenance is applied. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |
| [`userWhitelistedIpRanges`](#parameter-userwhitelistedipranges) | array | User added IP ranges to whitelist on ASE DB. Cannot be used with 'kind' `ASEv3`. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Switch to make the App Service Environment zone redundant. If enabled, the minimum App Service plan instance count will be three, otherwise 1. If enabled, the `dedicatedHostCount` must be set to `-1`. |

### Parameter: `allowNewPrivateEndpointConnections`

Property to enable and disable new private endpoint connection creation on ASE. Ignored when kind is set to ASEv2.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `clusterSettings`

Custom settings for changing the behavior of the App Service Environment.
- Required: No
- Type: array
- Default: `[System.Management.Automation.OrderedHashtable]`

### Parameter: `customDnsSuffix`

Enable the default custom domain suffix to use for all sites deployed on the ASE. If provided, then customDnsSuffixCertificateUrl and customDnsSuffixKeyVaultReferenceIdentity are required. Cannot be used when kind is set to ASEv2.
- Required: No
- Type: string
- Default: `''`

### Parameter: `customDnsSuffixCertificateUrl`

The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix. Required if customDnsSuffix is not empty. Cannot be used when kind is set to ASEv2.
- Required: No
- Type: string
- Default: `''`

### Parameter: `customDnsSuffixKeyVaultReferenceIdentity`

The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available. Required if customDnsSuffix is not empty. Cannot be used when kind is set to ASEv2.
- Required: No
- Type: string
- Default: `''`

### Parameter: `dedicatedHostCount`

The Dedicated Host Count. If `zoneRedundant` is false, and you want physical hardware isolation enabled, set to 2. Otherwise 0. Cannot be used when kind is set to ASEv2.
- Required: No
- Type: int
- Default: `0`

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

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, AppServiceEnvironmentPlatformLogs]`

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

### Parameter: `dnsSuffix`

DNS suffix of the App Service Environment.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `frontEndScaleFactor`

Scale factor for frontends.
- Required: No
- Type: int
- Default: `15`

### Parameter: `ftpEnabled`

Property to enable and disable FTP on ASEV3. Ignored when kind is set to ASEv2.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `inboundIpAddressOverride`

Customer provided Inbound IP Address. Only able to be set on Ase create. Ignored when kind is set to ASEv2.
- Required: No
- Type: string
- Default: `''`

### Parameter: `internalLoadBalancingMode`

Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing. "None" Exposes the ASE-hosted apps on an internet-accessible IP address.
- Required: No
- Type: string
- Default: `'None'`
- Allowed: `[None, Publishing, Web, Web, Publishing]`

### Parameter: `ipsslAddressCount`

Number of IP SSL addresses reserved for the App Service Environment. Cannot be used when kind is set to ASEv3.
- Required: No
- Type: int
- Default: `0`

### Parameter: `kind`

Kind of resource.
- Required: No
- Type: string
- Default: `'ASEv3'`
- Allowed: `[ASEv2, ASEv3]`

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

### Parameter: `multiSize`

Frontend VM size. Cannot be used when kind is set to ASEv3.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', ExtraLarge, Large, Medium, Standard_D1_V2, Standard_D2, Standard_D2_V2, Standard_D3, Standard_D3_V2, Standard_D4, Standard_D4_V2]`

### Parameter: `name`

Name of the App Service Environment.
- Required: Yes
- Type: string

### Parameter: `remoteDebugEnabled`

Property to enable and disable Remote Debug on ASEv3. Ignored when kind is set to ASEv2.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `subnetResourceId`

ResourceId for the subnet.
- Required: Yes
- Type: string

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Resource tags.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `upgradePreference`

Specify preference for when and how the planned maintenance is applied.
- Required: No
- Type: string
- Default: `'None'`
- Allowed: `[Early, Late, Manual, None]`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userWhitelistedIpRanges`

User added IP ranges to whitelist on ASE DB. Cannot be used with 'kind' `ASEv3`.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `zoneRedundant`

Switch to make the App Service Environment zone redundant. If enabled, the minimum App Service plan instance count will be three, otherwise 1. If enabled, the `dedicatedHostCount` must be set to `-1`.
- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the App Service Environment. |
| `resourceGroupName` | string | The resource group the App Service Environment was deployed into. |
| `resourceId` | string | The resource ID of the App Service Environment. |

## Cross-referenced modules

_None_

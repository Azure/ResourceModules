# ExpressRoute Circuits `[Microsoft.Network/expressRouteCircuits]`

This module deploys an Express Route Circuit.

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
| `Microsoft.Network/expressRouteCircuits` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/expressRouteCircuits) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.express-route-circuit:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using Maximum Parameters](#example-2-using-maximum-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteCircuit 'br:bicep/modules/network.express-route-circuit:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nerccom'
  params: {
    // Required parameters
    bandwidthInMbps: 50
    name: 'nerccom001'
    peeringLocation: 'Amsterdam'
    serviceProviderName: 'Equinix'
    // Non-required parameters
    allowClassicOperations: true
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    skuFamily: 'MeteredData'
    skuTier: 'Standard'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "bandwidthInMbps": {
      "value": 50
    },
    "name": {
      "value": "nerccom001"
    },
    "peeringLocation": {
      "value": "Amsterdam"
    },
    "serviceProviderName": {
      "value": "Equinix"
    },
    // Non-required parameters
    "allowClassicOperations": {
      "value": true
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
    "lock": {
      "value": "CanNotDelete"
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
    "skuFamily": {
      "value": "MeteredData"
    },
    "skuTier": {
      "value": "Standard"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Using Maximum Parameters_

This instance deploys the module with the large set of possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteCircuit 'br:bicep/modules/network.express-route-circuit:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nercmin'
  params: {
    // Required parameters
    bandwidthInMbps: 50
    name: 'nercmin001'
    peeringLocation: 'Amsterdam'
    serviceProviderName: 'Equinix'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "bandwidthInMbps": {
      "value": 50
    },
    "name": {
      "value": "nercmin001"
    },
    "peeringLocation": {
      "value": "Amsterdam"
    },
    "serviceProviderName": {
      "value": "Equinix"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
| [`bandwidthInMbps`](#parameter-bandwidthinmbps) | int | This is the bandwidth in Mbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call. |
| [`name`](#parameter-name) | string | This is the name of the ExpressRoute circuit. |
| [`peeringLocation`](#parameter-peeringlocation) | string | This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call. |
| [`serviceProviderName`](#parameter-serviceprovidername) | string | This is the name of the ExpressRoute Service Provider. It must exactly match one of the Service Providers from List ExpressRoute Service Providers API call. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowClassicOperations`](#parameter-allowclassicoperations) | bool | Allow classic operations. You can connect to virtual networks in the classic deployment model by setting allowClassicOperations to true. |
| [`bandwidthInGbps`](#parameter-bandwidthingbps) | int | The bandwidth of the circuit when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct. Default value of 0 will set the property to null. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`expressRoutePortResourceId`](#parameter-expressrouteportresourceid) | string | The reference to the ExpressRoutePort resource when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct. |
| [`globalReachEnabled`](#parameter-globalreachenabled) | bool | Flag denoting global reach status. To enable ExpressRoute Global Reach between different geopolitical regions, your circuits must be Premium SKU. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`peerASN`](#parameter-peerasn) | int | The autonomous system number of the customer/connectivity provider. |
| [`peering`](#parameter-peering) | bool | Enabled BGP peering type for the Circuit. |
| [`peeringType`](#parameter-peeringtype) | string | BGP peering type for the Circuit. Choose from AzurePrivatePeering, AzurePublicPeering or MicrosoftPeering. |
| [`primaryPeerAddressPrefix`](#parameter-primarypeeraddressprefix) | string | A /30 subnet used to configure IP addresses for interfaces on Link1. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`secondaryPeerAddressPrefix`](#parameter-secondarypeeraddressprefix) | string | A /30 subnet used to configure IP addresses for interfaces on Link2. |
| [`sharedKey`](#parameter-sharedkey) | string | The shared key for peering configuration. Router does MD5 hash comparison to validate the packets sent by BGP connection. This parameter is optional and can be removed from peering configuration if not required. |
| [`skuFamily`](#parameter-skufamily) | string | Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families. |
| [`skuTier`](#parameter-skutier) | string | Chosen SKU Tier of ExpressRoute circuit. Choose from Local, Premium or Standard SKU tiers. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vlanId`](#parameter-vlanid) | int | Specifies the identifier that is used to identify the customer. |

### Parameter: `allowClassicOperations`

Allow classic operations. You can connect to virtual networks in the classic deployment model by setting allowClassicOperations to true.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `bandwidthInGbps`

The bandwidth of the circuit when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct. Default value of 0 will set the property to null.
- Required: No
- Type: int
- Default: `0`

### Parameter: `bandwidthInMbps`

This is the bandwidth in Mbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call.
- Required: Yes
- Type: int

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
- Allowed: `['', allLogs, PeeringRouteLog]`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[AllMetrics]`
- Allowed: `[AllMetrics]`

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

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `expressRoutePortResourceId`

The reference to the ExpressRoutePort resource when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct.
- Required: No
- Type: string
- Default: `''`

### Parameter: `globalReachEnabled`

Flag denoting global reach status. To enable ExpressRoute Global Reach between different geopolitical regions, your circuits must be Premium SKU.
- Required: No
- Type: bool
- Default: `False`

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

This is the name of the ExpressRoute circuit.
- Required: Yes
- Type: string

### Parameter: `peerASN`

The autonomous system number of the customer/connectivity provider.
- Required: No
- Type: int
- Default: `0`

### Parameter: `peering`

Enabled BGP peering type for the Circuit.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `peeringLocation`

This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call.
- Required: Yes
- Type: string

### Parameter: `peeringType`

BGP peering type for the Circuit. Choose from AzurePrivatePeering, AzurePublicPeering or MicrosoftPeering.
- Required: No
- Type: string
- Default: `'AzurePrivatePeering'`
- Allowed: `[AzurePrivatePeering, MicrosoftPeering]`

### Parameter: `primaryPeerAddressPrefix`

A /30 subnet used to configure IP addresses for interfaces on Link1.
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `secondaryPeerAddressPrefix`

A /30 subnet used to configure IP addresses for interfaces on Link2.
- Required: No
- Type: string
- Default: `''`

### Parameter: `serviceProviderName`

This is the name of the ExpressRoute Service Provider. It must exactly match one of the Service Providers from List ExpressRoute Service Providers API call.
- Required: Yes
- Type: string

### Parameter: `sharedKey`

The shared key for peering configuration. Router does MD5 hash comparison to validate the packets sent by BGP connection. This parameter is optional and can be removed from peering configuration if not required.
- Required: No
- Type: string
- Default: `''`

### Parameter: `skuFamily`

Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families.
- Required: No
- Type: string
- Default: `'MeteredData'`
- Allowed: `[MeteredData, UnlimitedData]`

### Parameter: `skuTier`

Chosen SKU Tier of ExpressRoute circuit. Choose from Local, Premium or Standard SKU tiers.
- Required: No
- Type: string
- Default: `'Standard'`
- Allowed: `[Local, Premium, Standard]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `vlanId`

Specifies the identifier that is used to identify the customer.
- Required: No
- Type: int
- Default: `0`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of express route curcuit. |
| `resourceGroupName` | string | The resource group the express route curcuit was deployed into. |
| `resourceId` | string | The resource ID of express route curcuit. |
| `serviceKey` | string | The service key of the express route circuit. |

## Cross-referenced modules

_None_

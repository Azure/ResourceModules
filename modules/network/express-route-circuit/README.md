# ExpressRoute Circuits `[Microsoft.Network/expressRouteCircuits]`

This module deploys an Express Route Circuit.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/expressRouteCircuits` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/expressRouteCircuits) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `bandwidthInMbps` | int | This is the bandwidth in Mbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call. |
| `name` | string | This is the name of the ExpressRoute circuit. |
| `peeringLocation` | string | This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call. |
| `serviceProviderName` | string | This is the name of the ExpressRoute Service Provider. It must exactly match one of the Service Providers from List ExpressRoute Service Providers API call. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowClassicOperations` | bool | `False` |  | Allow classic operations. You can connect to virtual networks in the classic deployment model by setting allowClassicOperations to true. |
| `bandwidthInGbps` | int | `0` |  | The bandwidth of the circuit when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct. Default value of 0 will set the property to null. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, PeeringRouteLog]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `expressRoutePortResourceId` | string | `''` |  | The reference to the ExpressRoutePort resource when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct. |
| `globalReachEnabled` | bool | `False` |  | Flag denoting global reach status. To enable ExpressRoute Global Reach between different geopolitical regions, your circuits must be Premium SKU. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `peerASN` | int | `0` |  | The autonomous system number of the customer/connectivity provider. |
| `peering` | bool | `False` |  | Enabled BGP peering type for the Circuit. |
| `peeringType` | string | `'AzurePrivatePeering'` | `[AzurePrivatePeering, MicrosoftPeering]` | BGP peering type for the Circuit. Choose from AzurePrivatePeering, AzurePublicPeering or MicrosoftPeering. |
| `primaryPeerAddressPrefix` | string | `''` |  | A /30 subnet used to configure IP addresses for interfaces on Link1. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `secondaryPeerAddressPrefix` | string | `''` |  | A /30 subnet used to configure IP addresses for interfaces on Link2. |
| `sharedKey` | string | `''` |  | The shared key for peering configuration. Router does MD5 hash comparison to validate the packets sent by BGP connection. This parameter is optional and can be removed from peering configuration if not required. |
| `skuFamily` | string | `'MeteredData'` | `[MeteredData, UnlimitedData]` | Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families. |
| `skuTier` | string | `'Standard'` | `[Local, Premium, Standard]` | Chosen SKU Tier of ExpressRoute circuit. Choose from Local, Premium or Standard SKU tiers. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `vlanId` | int | `0` |  | Specifies the identifier that is used to identify the customer. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of express route curcuit. |
| `resourceGroupName` | string | The resource group the express route curcuit was deployed into. |
| `resourceId` | string | The resource ID of express route curcuit. |
| `serviceKey` | string | The service key of the express route circuit. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteCircuit './network/express-route-circuit/main.bicep' = {
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

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteCircuit './network/express-route-circuit/main.bicep' = {
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

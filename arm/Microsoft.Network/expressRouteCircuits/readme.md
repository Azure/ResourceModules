# ExpressRoute Circuit `[Microsoft.Network/expressRouteCircuits]`

This template deploys a ExrepressRoute Circuit.


## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Network/expressRouteCircuits` | 2021-02-01 |
| `Microsoft.Network/expressRouteCircuits/providers/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `bandwidthInMbps` | int |  |  | Required. This is the bandwidth in Mbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call. |
| `circuitName` | string |  |  | Required. This is the name of the ExpressRoute circuit |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[PeeringRouteLog]` | `[PeeringRouteLog]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `peerASN` | int |  |  | Optional. The autonomous system number of the customer/connectivity provider. |
| `peering` | bool |  | `[True, False]` | Optional. Enabled BGP peering type for the Circuit. |
| `peeringLocation` | string |  |  | Required. This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call. |
| `peeringType` | string | `AzurePrivatePeering` | `[AzurePrivatePeering, MicrosoftPeering]` | Optional. BGP peering type for the Circuit. Choose from AzurePrivatePeering, AzurePublicPeering or MicrosoftPeering. |
| `primaryPeerAddressPrefix` | string |  |  | Optional. A /30 subnet used to configure IP addresses for interfaces on Link1. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `secondaryPeerAddressPrefix` | string |  |  | Optional. A /30 subnet used to configure IP addresses for interfaces on Link2. |
| `serviceProviderName` | string |  |  | Required. This is the name of the ExpressRoute Service Provider. It must exactly match one of the Service Providers from List ExpressRoute Service Providers API call. |
| `sharedKey` | string |  |  | Optional. The shared key for peering configuration. Router does MD5 hash comparison to validate the packets sent by BGP connection. This parameter is optional and can be removed from peering configuration if not required. |
| `skuFamily` | string | `MeteredData` | `[MeteredData, UnlimitedData]` | Required. Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families. |
| `skuTier` | string | `Standard` | `[Standard, Premium]` | Required. Chosen SKU Tier of ExpressRoute circuit. Choose from Premium or Standard SKU tiers. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `vlanId` | int |  |  | Optional. Specifies the identifier that is used to identify the customer. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name | Type |
| :-- | :-- |
| `expressRouteCircuitName` | string |
| `expressRouteCircuitResourceGroup` | string |
| `expressRouteCircuitResourceId` | string |
| `expressRouteCircuitServiceKey` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)
- [Expressroutecircuits](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/expressRouteCircuits)

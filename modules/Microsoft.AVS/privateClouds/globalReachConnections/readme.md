# AVS PrivateClouds GlobalReachConnections `[Microsoft.AVS/privateClouds/globalReachConnections]`

This module deploys AVS PrivateClouds GlobalReachConnections.
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AVS/privateClouds/globalReachConnections` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.AVS/privateClouds/globalReachConnections) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the global reach connection in the private cloud |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateCloudName` | string | The name of the parent privateClouds. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `authorizationKey` | string | `''` | Authorization key from the peer express route used for the global reach connection |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `expressRouteId` | string | `''` | The ID of the Private Cloud's ExpressRoute Circuit that is participating in the global reach connection |
| `peerExpressRouteCircuit` | string | `''` | Identifier of the ExpressRoute Circuit to peer with in the global reach connection |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the globalReachConnection. |
| `resourceGroupName` | string | The name of the resource group the globalReachConnection was created in. |
| `resourceId` | string | The resource ID of the globalReachConnection. |

## Cross-referenced modules

_None_

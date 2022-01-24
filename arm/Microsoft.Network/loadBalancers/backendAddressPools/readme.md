# Load Balancers Backend Address Pools `[Microsoft.Network/loadBalancers/backendAddressPools]`

This module deploys load balancer backend address pools.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/loadBalancers/backendAddressPools` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `loadBalancerBackendAddresses` | array | `[]` |  | Optional. An array of backend addresses. |
| `loadBalancerName` | string |  |  | Required. The name of the parent load balancer |
| `name` | string |  |  | Required. The name of the backend address pool |
| `tunnelInterfaces` | array | `[]` |  | Optional. An array of gateway load balancer tunnel interfaces. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backend address pool |
| `resourceGroupName` | string | The resource group the backend address pool was deployed into |
| `resourceId` | string | The resource ID of the backend address pool |

## Template references

- [Loadbalancers/Backendaddresspools](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/loadBalancers/backendAddressPools)

# CDN Profiles Origin Group `[Microsoft.Cdn/profiles/originGroups]`

This module deploys a CDN Profile Origin Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/originGroups` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/profiles/originGroups) |
| `Microsoft.Cdn/profiles/originGroups/origins` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/profiles/originGroups/origins) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `loadBalancingSettings` | object | Load balancing settings for a backend pool. |
| `name` | string | The name of the origin group. |
| `origins` | array | The list of origins within the origin group. |
| `profileName` | string | The name of the CDN profile. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `healthProbeSettings` | object | `{object}` |  | Health probe settings to the origin that is used to determine the health of the origin. |
| `sessionAffinityState` | string | `'Disabled'` | `[Disabled, Enabled]` | Whether to allow session affinity on this host. |
| `trafficRestorationTimeToHealedOrNewEndpointsInMinutes` | int | `10` |  | Time in minutes to shift the traffic to the endpoint gradually when an unhealthy endpoint comes healthy or a new endpoint is added. Default is 10 mins. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the origin group. |
| `resourceGroupName` | string | The name of the resource group the origin group was created in. |
| `resourceId` | string | The resource id of the origin group. |

## Cross-referenced modules

_None_

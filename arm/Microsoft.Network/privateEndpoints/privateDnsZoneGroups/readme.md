# Network Private Endpoint Private DNS Zone Group `[Microsoft.Network/privateEndpoints/privateDnsZoneGroups]`

This module deploys a private endpoint private DNS zone group

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateDNSResourceIds` | array | List of private DNS resource IDs. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateEndpointName` | string | The name of the private endpoint. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `'default'` | The name of the private DNS Zone Group. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the private endpoint DNS zone group. |
| `resourceGroupName` | string | The resource group the private endpoint DNS zone group was deployed into. |
| `resourceId` | string | The resource ID of the private endpoint DNS zone group. |


# Private DNS Zone CNAME record `[Microsoft.Network/privateDnsZones/CNAME]`

This module deploys a Private DNS Zone CNAME record.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/CNAME` | 2020-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the CNAME record. |
| `privateDnsZoneName` | string | Private DNS zone name. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `cnameRecord` | object | `{object}` | A CNAME record. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `metadata` | object | `{object}` | The metadata attached to the record set. |
| `ttl` | int | `3600` | The TTL (time-to-live) of the records in the record set. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed CNAME record |
| `resourceGroupName` | string | The resource group of the deployed CNAME record |
| `resourceId` | string | The resource ID of the deployed CNAME record |

## Template references

- [Privatednszones/CNAME](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME)

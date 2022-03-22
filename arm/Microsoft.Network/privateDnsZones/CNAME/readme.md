# Private DNS Zone CNAME record `[Microsoft.Network/privateDnsZones/CNAME]`

This module deploys a Private DNS Zone CNAME record.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/CNAME` | 2020-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cnameRecord` | object | `{object}` |  | Optional. A CNAME record. |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `metadata` | object | `{object}` |  | Optional. The metadata attached to the record set. |
| `name` | string |  |  | Required. The name of the CNAME record. |
| `privateDnsZoneName` | string |  |  | Required. Private DNS zone name. |
| `ttl` | int | `3600` |  | Optional. The TTL (time-to-live) of the records in the record set. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed CNAME record |
| `resourceGroupName` | string | The resource group of the deployed CNAME record |
| `resourceId` | string | The resource ID of the deployed CNAME record |

## Template references

- [Privatednszones/CNAME](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME)

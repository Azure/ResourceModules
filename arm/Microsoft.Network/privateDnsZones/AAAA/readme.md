# Private DNS Zone AAAA record `[Microsoft.Network/privateDnsZones/AAAA]`

This module deploys a Private DNS Zone AAAA record.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/AAAA` | 2020-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `aaaaRecords` | array | `[]` |  | Optional. The list of AAAA records in the record set. |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `metadata` | object | `{object}` |  | Optional. The metadata attached to the record set. |
| `name` | string |  |  | Required. The name of the AAAA record. |
| `privateDnsZoneName` | string |  |  | Required. Private DNS zone name. |
| `ttl` | int | `3600` |  | Optional. The TTL (time-to-live) of the records in the record set. |

### Parameter Usage: `aaaaRecords`

```json
"aaaaRecords": {
    "value": [
      {
        "ipv6Address": "string"
      }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed AAAA record |
| `resourceGroupName` | string | The resource group of the deployed AAAA record |
| `resourceId` | string | The resource ID of the deployed AAAA record |

## Template references

- [Privatednszones/AAAA](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA)

# Private DNS Zone TXT record `[Microsoft.Network/privateDnsZones/TXT]`

This module deploys a Private DNS Zone TXT record.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/TXT` | 2020-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `metadata` | object | `{object}` |  | Optional. The metadata attached to the record set. |
| `name` | string |  |  | Required. The name of the TXT record. |
| `privateDnsZoneName` | string |  |  | Required. Private DNS zone name. |
| `ttl` | int | `3600` |  | Optional. The TTL (time-to-live) of the records in the record set. |
| `txtRecords` | array | `[]` |  | Optional. The list of TXT records in the record set. |

### Parameter Usage: `txtRecords`

```json
"txtRecords": {
    "value": [
      {
        "value": [ "string" ]
      }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed TXT record |
| `resourceGroupName` | string | The resource group of the deployed TXT record |
| `resourceId` | string | The resource ID of the deployed TXT record |

## Template references

- [Privatednszones/TXT](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT)

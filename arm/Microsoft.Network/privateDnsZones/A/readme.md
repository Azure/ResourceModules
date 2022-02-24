# Network Private Dns Zones A record `[Microsoft.Network/privateDnsZones/A]`

This module deploys Network PrivateDnsZones A record.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/A` | 2020-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `aRecords` | array | `[]` |  | Optional. The list of A records in the record set. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `metadata` | object | `{object}` |  | Optional. The metadata attached to the record set. |
| `name` | string |  |  | Required. The name of the A record. |
| `privateDnsZoneName` | string |  |  | Required. Private DNS zone name. |
| `ttl` | int | `3600` |  | Optional. The TTL (time-to-live) of the records in the record set. |

### Parameter Usage: `aRecords`

```json
"aRecords": {
    "value": [
      {
        "ipv4Address": "string"
      }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed A record |
| `resourceGroupName` | string | The resource group of the deployed A record |
| `resourceId` | string | The resource ID of the deployed A record |

## Template references

- [Privatednszones/A](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A)

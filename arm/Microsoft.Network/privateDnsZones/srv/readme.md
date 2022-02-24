# Network Private Dns Zones SRV record `[Microsoft.Network/privateDnsZones/SRV]`

This module deploys Network PrivateDnsZones TXT record.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/SRV` | 2020-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `metadata` | object | `{object}` |  | Optional. The metadata attached to the record set. |
| `name` | string |  |  | Required. The name of the A record. |
| `privateDnsZoneName` | string |  |  | Required. Private DNS zone name. |
| `srvRecords` | array | `[]` |  | Optional. The list of SRV records in the record set. |
| `ttl` | int | `3600` |  | Optional. The TTL (time-to-live) of the records in the record set. |

### Parameter Usage: `srvRecords`

```json
"srvRecords": {
    "value": [
      {
        "port": "int",
        "priority": "int",
        "target": "string",
        "weight": "int"
      }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed SRV record |
| `resourceGroupName` | string | The resource group of the deployed SRV record |
| `resourceId` | string | The resource ID of the deployed SRV record |

## Template references

- [Privatednszones/SRV](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV)

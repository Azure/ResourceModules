# Network Private Dns Zones A record `[Microsoft.Network/privateDnsZones/A]`

This module deploys Network PrivateDnsZones A record.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/A` | 2020-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `aaaaRecords` | array | `[]` |  | Optional. The list of AAAA records in the record set. |
| `aRecords` | array | `[]` |  | Optional. The list of A records in the record set. |
| `cname` | string |  |  | Optional. The canonical name for this CNAME record. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `metadata` | object | `{object}` |  | Optional. The metadata attached to the record set. |
| `mxRecords` | array | `[]` |  | Optional. The list of MX records in the record set. |
| `name` | string |  |  | Required. The name of the A record. |
| `privateDnsZoneName` | string |  |  | Required. Private DNS zone name. |
| `ptrRecords` | array | `[]` |  | Optional. The list of PTR records in the record set. |
| `soaRecord` | object | `{object}` |  | Optional. A SOA record. |
| `srvRecords` | array | `[]` |  | Optional. The list of SRV records in the record set. |
| `ttl` | int | `3600` |  | Optional. The TTL (time-to-live) of the records in the record set. |
| `txtRecords` | array | `[]` |  | Optional. The list of TXT records in the record set. |

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

### Parameter Usage: `mxRecords`

```json
"mxRecords": {
    "value": [
      {
        "exchange": "string",
        "preference": "int"
      }
    ]
}
```

### Parameter Usage: `ptrRecords`

```json
"ptrRecords": {
    "value": [
      {
        "ptrdname": "string"
      }
    ]
}
```

### Parameter Usage: `soaRecord`

```json
"soaRecord": {
    "value": {
      "email": "string",
      "expireTime": "int",
      "host": "string",
      "minimumTtl": "int",
      "refreshTime": "int",
      "retryTime": "int",
      "serialNumber": "int"
    }
}
```

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
| `name` | string | The name of the deployed A record |
| `resourceGroupName` | string | The resource group of the deployed A record |
| `resourceId` | string | The resource ID of the deployed A record |

## Template references

- [Privatednszones/A](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A)

# Private DNS Zone SOA record `[Microsoft.Network/privateDnsZones/SOA]`

This module deploys a Private DNS Zone SOA record.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/SOA` | 2020-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the SOA record. |
| `privateDnsZoneName` | string | Private DNS zone name. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `metadata` | object | `{object}` | The metadata attached to the record set. |
| `soaRecord` | object | `{object}` | A SOA record. |
| `ttl` | int | `3600` | The TTL (time-to-live) of the records in the record set. |


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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed SOA record |
| `resourceGroupName` | string | The resource group of the deployed SOA record |
| `resourceId` | string | The resource ID of the deployed SOA record |

## Template references

- [Privatednszones/SOA](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA)

# Private DNS Zone TXT record `[Microsoft.Network/privateDnsZones/TXT]`

This module deploys a Private DNS Zone TXT record.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/TXT` | 2020-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the TXT record. |
| `privateDnsZoneName` | string | Private DNS zone name. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `metadata` | object | `{object}` | The metadata attached to the record set. |
| `ttl` | int | `3600` | The TTL (time-to-live) of the records in the record set. |
| `txtRecords` | array | `[]` | The list of TXT records in the record set. |


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

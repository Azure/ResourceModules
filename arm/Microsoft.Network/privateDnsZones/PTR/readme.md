# Private DNS Zone PTR record `[Microsoft.Network/privateDnsZones/PTR]`

This module deploys a Private DNS Zone PTR record.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/PTR` | 2020-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the PTR record. |
| `privateDnsZoneName` | string | Private DNS zone name. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `metadata` | object | `{object}` | The metadata attached to the record set. |
| `ptrRecords` | array | `[]` | The list of PTR records in the record set. |
| `ttl` | int | `3600` | The TTL (time-to-live) of the records in the record set. |


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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed PTR record |
| `resourceGroupName` | string | The resource group of the deployed PTR record |
| `resourceId` | string | The resource ID of the deployed PTR record |

## Template references

- [Privatednszones/PTR](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR)

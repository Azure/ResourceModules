# Private DNS Zone SRV record `[Microsoft.Network/privateDnsZones/SRV]`

This module deploys a Private DNS Zone TXT record.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/SRV` | 2020-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the SRV record. |
| `privateDnsZoneName` | string | Private DNS zone name. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `metadata` | object | `{object}` | The metadata attached to the record set. |
| `srvRecords` | array | `[]` | The list of SRV records in the record set. |
| `ttl` | int | `3600` | The TTL (time-to-live) of the records in the record set. |


### Parameter Usage: `srvRecords`

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
srvRecords: [
    {
        port: 'int'
        priority: 'int'
        target: 'string'
        weight: 'int'
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed SRV record |
| `resourceGroupName` | string | The resource group of the deployed SRV record |
| `resourceId` | string | The resource ID of the deployed SRV record |



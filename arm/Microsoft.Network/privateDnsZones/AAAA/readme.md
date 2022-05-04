# Private DNS Zone AAAA record `[Microsoft.Network/privateDnsZones/AAAA]`

This module deploys a Private DNS Zone AAAA record.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the AAAA record. |
| `privateDnsZoneName` | string | Private DNS zone name. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `aaaaRecords` | array | `[]` | The list of AAAA records in the record set. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `metadata` | object | `{object}` | The metadata attached to the record set. |
| `roleAssignments` | array | `[]` | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `ttl` | int | `3600` | The TTL (time-to-live) of the records in the record set. |


### Parameter Usage: `aaaaRecords`

<details>

<summary>Parameter JSON format</summary>

```json
"aaaaRecords": {
    "value": [
        {
            "ipv6Address": "string"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
aaaaRecords: [
    {
        ipv6Address: 'string'
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed AAAA record |
| `resourceGroupName` | string | The resource group of the deployed AAAA record |
| `resourceId` | string | The resource ID of the deployed AAAA record |



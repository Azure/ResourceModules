# Public DNS Zone TXT record `[Microsoft.Network/dnsZones/TXT]`

This module deploys a Public DNS Zone TXT record.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/dnsZones/TXT` | [2018-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-05-01/dnsZones/TXT) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the TXT record. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `dnsZoneName` | string | The name of the parent DNS zone. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `metadata` | object | `{object}` | The metadata attached to the record set. |
| `roleAssignments` | array | `[]` | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `ttl` | int | `3600` | The TTL (time-to-live) of the records in the record set. |
| `txtRecords` | array | `[]` | The list of TXT records in the record set. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed TXT record. |
| `resourceGroupName` | string | The resource group of the deployed TXT record. |
| `resourceId` | string | The resource ID of the deployed TXT record. |

## Cross-referenced modules

_None_

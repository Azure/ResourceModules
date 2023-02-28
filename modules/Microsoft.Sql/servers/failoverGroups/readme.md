# `[Microsoft.Sql/servers/failoverGroups]`

This module deploys a failover group for Azure SQL Database

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/failoverGroups` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/failoverGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Failover group. |
| `partnerServerId` | array | An array containing a PartnerInfo object. [{id: resourceID}] |
| `serverName` | string | The name of the parent SQL Server. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `databases` | array | `[]` |  | The name of the databases to include in the failover group. |
| `failoverPolicy` | string | `'Manual'` | `[Automatic, Manual]` | The failover policy. |
| `failoverWithDataLossGracePeriodMinutes` | int | `60` |  | The failover data loss grace period. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed azure sql failover group. |
| `resourceGroupName` | string | The resource group of the deployed azure sql failover group. |
| `resourceId` | string | The resource ID of the deployed azure sql failover group. |

## Cross-referenced modules

_None_

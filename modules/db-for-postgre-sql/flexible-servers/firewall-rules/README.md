# DBforPostgreSQL Flexible Server Firewall Rules `[Microsoft.DBforPostgreSQL/flexibleServers/firewallRules]`

This module deploys a DBforPostgreSQL Flexible Server Firewall Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforPostgreSQL/flexibleServers/firewallRules` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/firewallRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `endIpAddress` | string | The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses. |
| `name` | string | The name of the PostgreSQL flexible server Firewall Rule. |
| `startIpAddress` | string | The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `flexibleServerName` | string | The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed firewall rule. |
| `resourceGroupName` | string | The resource group of the deployed firewall rule. |
| `resourceId` | string | The resource ID of the deployed firewall rule. |

## Cross-referenced modules

_None_

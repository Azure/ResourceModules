# Azure SQL Server Firewall Rule `[Microsoft.Sql/servers/firewallRules]`

This module deploys an Azure SQL Server Firewall Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/firewallRules` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/firewallRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Server Firewall Rule. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `serverName` | string | The name of the parent SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `endIpAddress` | string | `'0.0.0.0'` | The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses. |
| `startIpAddress` | string | `'0.0.0.0'` | The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed firewall rule. |
| `resourceGroupName` | string | The resource group of the deployed firewall rule. |
| `resourceId` | string | The resource ID of the deployed firewall rule. |

## Cross-referenced modules

_None_

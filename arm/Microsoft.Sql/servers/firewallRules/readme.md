# SQL Server Firewall rule `[Microsoft.Sql/servers/firewallrules]`

This module deploys an SQL Server Firewall rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/firewallRules` | 2021-05-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Server Firewall Rule. |
| `serverName` | string | The Name of SQL Server |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `endIpAddress` | string | `'0.0.0.0'` | The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses. |
| `startIpAddress` | string | `'0.0.0.0'` | The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed firewall rule |
| `resourceGroupName` | string | The resourceGroup of the deployed firewall rule |
| `resourceId` | string | The resource ID of the deployed firewall rule |

## Template references

- [Servers/Firewallrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/servers/firewallRules)

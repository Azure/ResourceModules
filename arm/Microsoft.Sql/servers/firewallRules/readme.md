# SQL Server Firewall rule `[Microsoft.Sql/servers/firewallrules]`

This module deploys an SQL Server Firewall rule.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/firewallRules` | 2021-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `endIpAddress` | string | `0.0.0.0` |  | Optional. The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses. |
| `name` | string |  |  | Required. The name of the Server Firewall Rule. |
| `serverName` | string |  |  | Required. The Name of SQL Server |
| `startIpAddress` | string | `0.0.0.0` |  | Optional. The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `databaseId` | string | The resource ID of the deployed firewall rule |
| `databaseName` | string | The name of the deployed firewall rule |
| `databaseResourceGroup` | string | The resourceGroup of the deployed firewall rule |

## Template references

- [Servers/Firewallrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/servers/firewallRules)

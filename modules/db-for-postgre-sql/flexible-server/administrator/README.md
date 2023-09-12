# DBforPostgreSQL Flexible Server Administrators `[Microsoft.DBforPostgreSQL/flexibleServers/administrators]`

This module deploys a DBforPostgreSQL Flexible Server Administrator.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforPostgreSQL/flexibleServers/administrators` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/administrators) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `objectId` | string |  | The objectId of the Active Directory administrator. |
| `principalName` | string |  | Active Directory administrator principal name. |
| `principalType` | string | `[Group, ServicePrincipal, Unknown, User]` | The principal type used to represent the type of Active Directory Administrator. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `flexibleServerName` | string | The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `tenantId` | string | `[tenant().tenantId]` | The tenantId of the Active Directory administrator. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed administrator. |
| `resourceGroupName` | string | The resource group of the deployed administrator. |
| `resourceId` | string | The resource ID of the deployed administrator. |

## Cross-referenced modules

_None_

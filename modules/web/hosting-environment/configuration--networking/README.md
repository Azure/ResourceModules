# Hosting Environment Network Configuration `[Microsoft.Web/hostingEnvironments/configurations]`

This module deploys a Hosting Environment Network Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/hostingEnvironments/configurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/hostingEnvironments/configurations) |

## Parameters

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `hostingEnvironmentName` | string | The name of the parent Hosting Environment. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `allowNewPrivateEndpointConnections` | bool | `False` | Property to enable and disable new private endpoint connection creation on ASE. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `ftpEnabled` | bool | `False` | Property to enable and disable FTP on ASEV3. |
| `inboundIpAddressOverride` | string | `''` | Customer provided Inbound IP Address. Only able to be set on Ase create. |
| `remoteDebugEnabled` | bool | `False` | Property to enable and disable Remote Debug on ASEv3. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the configuration. |
| `resourceGroupName` | string | The resource group of the deployed configuration. |
| `resourceId` | string | The resource ID of the deployed configuration. |

## Cross-referenced modules

_None_

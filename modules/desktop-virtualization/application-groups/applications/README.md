# Azure Virtual Desktop (AVD) Application Group Applications `[Microsoft.DesktopVirtualization/applicationGroups/applications]`

This module deploys an Azure Virtual Desktop (AVD) Application Group Application.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DesktopVirtualization/applicationGroups/applications` | [2022-09-09](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2022-09-09/applicationGroups/applications) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `filePath` | string | Specifies a path for the executable file for the application. |
| `friendlyName` | string | Friendly name of Application.. |
| `name` | string | Name of the Application to be created in the Application Group. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `appGroupName` | string | The name of the parent Application Group to create the application(s) in. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `commandLineArguments` | string | `''` |  | Command-Line Arguments for Application. |
| `commandLineSetting` | string | `'DoNotAllow'` | `[Allow, DoNotAllow, Require]` | Specifies whether this published application can be launched with command-line arguments provided by the client, command-line arguments specified at publish time, or no command-line arguments at all. |
| `description` | string | `''` |  | Description of Application.. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `iconIndex` | int | `0` |  | Index of the icon. |
| `iconPath` | string | `''` |  | Path to icon. |
| `showInPortal` | bool | `False` |  | Specifies whether to show the RemoteApp program in the RD Web Access server. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The Name of the Application Group to register the Application in. |
| `resourceGroupName` | string | The name of the Resource Group the AVD Application was created in. |
| `resourceId` | string | The resource ID of the deployed Application. |

## Cross-referenced modules

_None_

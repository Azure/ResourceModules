# AVD Applications `[Microsoft.DesktopVirtualization/applicationGroups/applications]`

This module deploys AVD Applications.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DesktopVirtualization/applicationGroups/applications` | 2021-07-12 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appGroupName` | string |  |  | Required. Name of the Application Group to create the application(s) in. |
| `commandLineArguments` | string |  |  | Optional. Command-Line Arguments for Application. |
| `commandLineSetting` | string | `DoNotAllow` | `[Allow, DoNotAllow, Require]` | Optional. Specifies whether this published application can be launched with command-line arguments provided by the client, command-line arguments specified at publish time, or no command-line arguments at all. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `description` | string |  |  | Optional. Description of Application.. |
| `filePath` | string |  |  | Required. Specifies a path for the executable file for the application. |
| `friendlyName` | string |  |  | Required. Friendly name of Application.. |
| `iconIndex` | int |  |  | Optional. Index of the icon. |
| `iconPath` | string |  |  | Optional. Path to icon. |
| `name` | string |  |  | Required. Name of the Application to be created in the Application Group. |
| `showInPortal` | bool |  |  | Optional. Specifies whether to show the RemoteApp program in the RD Web Access server. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `applicationResourceIds` | string | The resource ID of the deployed Application. |
| `name` | string | The Name of the Application Group to register the Application in. |
| `resourceGroupName` | string | The name of the Resource Group the AVD Application was created in. |

## Template references

- [Applicationgroups/Applications](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2021-07-12/applicationGroups/applications)

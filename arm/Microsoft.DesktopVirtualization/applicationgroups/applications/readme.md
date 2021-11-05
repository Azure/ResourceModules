# AVD Applications  `[Microsoft.DesktopVirtualization/applicationGroups/applications]`

This module deploys AVD Applications.

## Resource types
| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.DesktopVirtualization/applicationGroups/applications` | 2021-07-12 |

## Parameters
| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appDescription` | string |  |  | Required. Description of Application.. |
| `appGroupName` | string |  |  | Required. Name of the Application Group to create the application(s) in. |
| `commandLineArguments` | string |  |  | Required. Command Line Arguments for Application. |
| `commandLineSetting` | string |  | `[Allow, DoNotAllow, Require]` | Required. Specifies whether this published application can be launched with command line arguments provided by the client, command line arguments specified at publish time, or no command line arguments at all. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `filePath` | string |  |  | Required. Specifies a path for the executable file for the application.. |
| `friendlyName` | string |  |  | Required. Friendly name of Application.. |
| `iconIndex` | int |  |  | Required. Index of the icon. |
| `iconPath` | string |  |  | Required. Path to icon. |
| `name` | string |  |  | Required. Name of the Application to be created in the Application Group. |
| `showInPortal` | bool |  |  | Required. Specifies whether to show the RemoteApp program in the RD Web Access server. |

## Outputs
| Output Name | Type | Description
| :-- | :-- | :-- |
| `appGroupName` | string | The Name of the Application Group to register the Application in. |
| `applicationResourceGroup` | string | The name of the Resource Group the AVD Application was created in. |
| `applicationResourceIds` | string | The resource id of the deployed Application. |

## Template references
- [Applicationgroups/Applications](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2021-07-12/applicationGroups/applications)

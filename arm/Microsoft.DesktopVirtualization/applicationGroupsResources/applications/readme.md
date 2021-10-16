# AVD Applications

This module deploys AVD Applications.



## Resource types
| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.DesktopVirtualization/applicationGroups/applications` | 2021-07-12 |

## Parameters
| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appGroupName` | string |  |  | Required. Name of the Application Group to create the application(s) in. |
| `applications` | array |  |  | Required. List of applications to be created in the Application Group. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |

### Parameter Usage: `applications`

```json
"applications": {
    "value": [
        {
            "name": "notepad",
            "description": "Notepad by ARM template",
            "friendlyName": "Notepad",
            "filePath": "C:\\Windows\\System32\\notepad.exe",
            "commandLineSetting": "DoNotAllow",
            "commandLineArguments": "",
            "showInPortal": true,
            "iconPath": "C:\\Windows\\System32\\notepad.exe",
            "iconIndex": 0
        },
        {
            "name": "wordpad",
            "description": "WordPad by ARM template 2",
            "friendlyName": "WordPad",
            "filePath": "C:\\Program Files\\Windows NT\\Accessories\\wordpad.exe",
            "commandLineSetting": "DoNotAllow",
            "commandLineArguments": "",
            "showInPortal": true,
            "iconPath": "C:\\Program Files\\Windows NT\\Accessories\\wordpad.exe",
            "iconIndex": 0
        }
    ]
}
```

## Outputs
| Output Name | Type |
| :-- | :-- |
| `appGroupName` | string |
| `applicationResourceGroup` | string |
| `applicationResourceIds` | array |

## Template references
- [Applicationgroups/Applications](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2021-07-12/applicationGroups/applications)

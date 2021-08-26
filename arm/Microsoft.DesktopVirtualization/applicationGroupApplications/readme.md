# WVD Applications

This module deploys WVD Applications.



## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.DesktopVirtualization/applicationGroups/applications`|2019-12-10-preview|


## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `appGroupName` | string | Required. Name of the Application Group to create the application(s) in. |  |  |
| `applications` | array | Required. List of applications to be created in the Application Group. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `appGroupName` | string | The Name of the Application Group to register the Application(s) in. |
| `applicationResourceGroup` | string | The name of the Resource Group the WVD Applications were created in. |
| `applicationResourceIds` | array | The list of the application resourceIds deployed. |


## Considerations

*N/A*

## Additional resources

- [What is Windows Virtual Desktop?](https://docs.microsoft.com/en-us/azure/virtual-desktop/overview)
- [Windows Virtual Desktop environment](https://docs.microsoft.com/en-us/azure/virtual-desktop/environment-setup)

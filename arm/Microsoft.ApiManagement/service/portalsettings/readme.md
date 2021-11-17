# Api Management Service Portal Settings `[Microsoft.ApiManagement/service/portalsettings]`

This module deploys Api Management Service Portal Setting.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/portalsettings` | 2019-12-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the Api Management service. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. Portal setting name |
| `properties` | object | `{object}` |  | Optional. Portal setting properties. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `portalSettingsName` | string | The name of the API management service portal setting |
| `portalSettingsResourceGroup` | string | The resource group the API management service portal setting was deployed into |
| `portalSettingsResourceId` | string | The resourceId of the API management service portal setting |

## Template references

- [Service/Portalsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2019-12-01/service/portalsettings)

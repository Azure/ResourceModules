# ApimanagementServicePortalsettings `[Microsoft.ApiManagement/service/portalsettings]`

// TODO: Replace Resource and fill in description

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
| `properties` | object | `{object}` |  | Optional. Portal settings properties. |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `portalSettingsName` | string | The name of the API management service portal settings |
| `portalSettingsResourceGroup` | string | The resource group the API management service portal settings was deployed into |
| `portalSettingsResourceId` | string | The resourceId of the API management service portal settings |

## Template references

- [Service/Portalsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2019-12-01/service/portalsettings)

# API Management Service API Version Sets `[Microsoft.ApiManagement/service/apiVersionSets]`

This module deploys API Management Service APIs Version Set.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apiVersionSets` | 2020-06-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string | `default` |  | Optional. API Version set name |
| `properties` | object | `{object}` |  | Optional. API Version set properties |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `apiVersionSetName` | string | The name of the API Version set |
| `apiVersionSetResourceGroup` | string | The resource group the API Version set was deployed into |
| `apiVersionSetResourceId` | string | The resource ID of the API Version set |

## Template references

- [Service/Apiversionsets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/apiVersionSets)

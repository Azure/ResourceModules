# ApimanagementServiceProductsApis `[Microsoft.ApiManagement/service/products/apis]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/products/apis` | 2020-06-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the Api Management service. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. Name of the product api. |
| `productName` | string |  |  | Required. The name of the of the Product. |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `apiName` | string | The name of the product api |
| `apiResourceGroup` | string | The resource group the product api was deployed into |
| `apiResourceId` | string | The resourceId of the product api |

## Template references

- [Service/Products/Apis](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/products/apis)

# API Management Service Products Groups `[Microsoft.ApiManagement/service/products/groups]`

This module deploys API Management Service Product Groups.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/products/groups` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. Name of the product group. |
| `productName` | string |  |  | Required. The name of the of the Product. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the product group |
| `resourceGroupName` | string | The resource group the product group was deployed into |
| `resourceId` | string | The resource ID of the product group |

## Template references

- [Service/Products/Groups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/products/groups)

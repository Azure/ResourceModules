# Api Management Service Products  `[Microsoft.ApiManagement/service/products]`

This module deploys Api Management Service Products.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/products` | 2020-06-01-preview |
| `Microsoft.ApiManagement/service/products/apis` | 2020-06-01-preview |
| `Microsoft.ApiManagement/service/products/groups` | 2020-06-01-preview |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the Api Management service. |
| `approvalRequired` | bool |  |  | Optional. Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product�s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product�s APIs. Can be present only if subscriptionRequired property is present and has a value of false. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `productApis` | array | `[]` |  | Optional. Product API's name list. |
| `productDescription` | string |  |  | Optional. Product description. May include HTML formatting tags. |
| `productGroups` | array | `[]` |  | Optional. Product's Group name list. |
| `name` | string |  |  | Required. Product Name. |
| `state` | string | `published` |  | Optional. whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished. - notPublished or published |
| `subscriptionRequired` | bool |  |  | Optional. Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true. |
| `subscriptionsLimit` | int | `1` |  | Optional. Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false. |
| `terms` | string |  |  | Optional. Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process. |

### Parameter Usage: `productApis`

Product API's name list.

```json
"productApis": {
    "value":[
        "api-1",
        "api-2"
    ]
}
```

Product groups list.

```json
"productGroups": {
    "value":[
        "developers"
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `productApisResourceIds` | array | The Resources Ids of the API management service product apis |
| `productGroupsResourceIds` | array | The Resources Ids of the API management service product groups |
| `productName` | string | The name of the API management service product |
| `productResourceGroup` | string | The resource group the API management service product was deployed into |
| `productResourceId` | string | The resource Id of the API management service product |

## Template references

- [Service/Products](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/products)
- [Service/Products/Apis](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/products/apis)
- [Service/Products/Groups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/products/groups)

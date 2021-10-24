# Api Management Subscriptions  `[Microsoft.ApiManagement/service/subscriptions]`

This module deploys Api Management Subscriptions.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/subscriptions` | 2020-06-01-preview |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowTracing` | bool | `True` |  | Optional. Determines whether tracing can be enabled. |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the Api Management service. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `ownerId` | string |  |  | Optional. User (user id path) for whom subscription is being created in form /users/{userId} |
| `primaryKey` | string |  |  | Optional. Primary subscription key. If not specified during request key will be generated automatically. |
| `scope` | string | `/apis` |  | Required. Scope type to choose between a product, allApis or a specific api. Scope like /products/{productId} or /apis or /apis/{apiId}. |
| `secondaryKey` | string |  |  | Optional. Secondary subscription key. If not specified during request key will be generated automatically. |
| `state` | string |  |  | Optional. Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are * active ? the subscription is active, * suspended ? the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled |
| `subscriptionName` | string |  |  | Required. Subscription name. |

## Outputs

| Output Name | Type |
| :-- | :-- |
| `subscriptionResourceGroup` | string |
| `subscriptionResourceId` | string |
| `subscriptionResourceName` | string |

## Template references

- [Service/Subscriptions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/subscriptions)

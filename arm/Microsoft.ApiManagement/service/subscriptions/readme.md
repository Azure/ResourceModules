# API Management Subscriptions `[Microsoft.ApiManagement/service/subscriptions]`

This module deploys API Management Subscriptions.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/subscriptions` | 2021-08-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.ApiManagement/service`

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowTracing` | bool | `True` |  | Optional. Determines whether tracing can be enabled. |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string |  |  | Required. Subscription name. |
| `ownerId` | string |  |  | Optional. User (user ID path) for whom subscription is being created in form /users/{userId} |
| `primaryKey` | string |  |  | Optional. Primary subscription key. If not specified during request key will be generated automatically. |
| `scope` | string | `/apis` |  | Optional. Scope type to choose between a product, "allAPIs" or a specific API. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}". |
| `secondaryKey` | string |  |  | Optional. Secondary subscription key. If not specified during request key will be generated automatically. |
| `state` | string |  |  | Optional. Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are "*" active "?" the subscription is active, "*" suspended "?" the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service subscription |
| `resourceGroupName` | string | The resource group the API management service subscription was deployed into |
| `resourceId` | string | The resource ID of the API management service subscription |

## Template references

- [Service/Subscriptions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/subscriptions)

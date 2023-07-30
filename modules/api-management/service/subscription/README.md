# API Management Service Subscriptions `[Microsoft.ApiManagement/service/subscriptions]`

This module deploys an API Management Service Subscription.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/subscriptions` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/subscriptions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Subscription name. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `apiManagementServiceName` | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `allowTracing` | bool | `True` | Determines whether tracing can be enabled. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `ownerId` | string | `''` | User (user ID path) for whom subscription is being created in form /users/{userId}. |
| `primaryKey` | string | `''` | Primary subscription key. If not specified during request key will be generated automatically. |
| `scope` | string | `'/apis'` | Scope type to choose between a product, "allAPIs" or a specific API. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}". |
| `secondaryKey` | string | `''` | Secondary subscription key. If not specified during request key will be generated automatically. |
| `state` | string | `''` | Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are "*" active "?" the subscription is active, "*" suspended "?" the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service subscription. |
| `resourceGroupName` | string | The resource group the API management service subscription was deployed into. |
| `resourceId` | string | The resource ID of the API management service subscription. |

## Cross-referenced modules

_None_

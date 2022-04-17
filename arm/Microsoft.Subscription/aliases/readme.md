# Subscription Aliases `[Microsoft.Subscription/aliases]`

This module deploys a Subscription Alias.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Management/managementGroups/subscriptions` | 2021-04-01 |
| `Microsoft.Subscription/aliases` | 2021-10-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `alias` | string | Alias to assign to the subscription |

**Conditional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `billingAccount` | string | `''` | BillingAccount used for subscription billing. Required if no subscriptionId was provided. |
| `displayName` | string | `''` | Display name for the subscription. Required if no subscriptionId was provided. |
| `enrollmentAccount` | string | `''` | EnrollmentAccount used for subscription billing. Required if no subscriptionId was provided. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `managementGroupId` | string | `''` |  | The ID of the management group to deploy into. If not provided the subscription is deployed into the root management group |
| `ownerId` | string | `''` |  | Owner Id of the subscription |
| `subscriptionId` | string | `''` |  | This parameter can be used to create alias for an existing subscription Id |
| `tags` | object | `{object}` |  | Tags for the subscription |
| `tenantId` | string | `''` |  | Tenant Id of the subscription |
| `workload` | string | `'Production'` | `[Production, DevTest]` | The workload type of the subscription. |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed subscription alias |
| `resourceId` | string | The resource ID of the deployed subscription alias |
| `subscriptionId` | string | The subscription ID attached to the deployed alias |

## Template references

- [Aliases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Subscription/2021-10-01/aliases)
- [Managementgroups/Subscriptions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Management/2021-04-01/managementGroups/subscriptions)

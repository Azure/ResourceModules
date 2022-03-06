# Subscription Aliases `[Microsoft.Subscription/aliases]`

This module deploys a Subscription Alias.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Management/managementGroups/subscriptions` | 2021-04-01 |
| `Microsoft.Subscription/aliases` | 2021-10-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `billingAccount` | string |  |  | Required. BillingAccount used for subscription billing |
| `enrollmentAccount` | string |  |  | Required. EnrollmentAccount used for subscription billing |
| `managementGroupId` | string |  |  | Optional. The ID of the management group to deploy into. If not provided the subscription is deployed into the root management group |
| `subscriptionAlias` | string |  |  | Required. Alias to assign to the subscription |
| `subscriptionDisplayName` | string |  |  | Required. Display name for the subscription |
| `subscriptionId` | string |  |  | Optional. This parameter can be used to create alias for existing subscription Id |
| `subscriptionOwnerId` | string |  |  | Optional. Owner Id of the subscription |
| `subscriptionTenantId` | string |  |  | Optional. Tenant Id of the subscription |
| `subscriptionWorkload` | string | `Production` | `[Production, DevTest]` | Optional. The workload type of the subscription. |
| `tags` | object | `{object}` |  | Optional. Tags for the subscription |

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

#  Subscription policies `[Microsoft.Subscription/policies]`

This module deploys [subscription policies](https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/manage-azure-subscription-policy) to an Azure Tenant.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Subscription/policies` | 2021-10-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `blockSubscriptionsIntoTenant` | bool |  |  | Blocks users from moving Azure subscriptions from this AAD directory to a different one. |
| `blockSubscriptionsLeavingTenant` | bool |  |  | Blocks users from moving Azure subscriptions from a different AAD directory to a this one. |
| `exemptedPrincipals` | array | `[]` |  | A list of users who can bypass the policy definitions and will always be able to move subscriptions out or in of this AAD directory. |

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `policyId` | string | The object ID of the subscription policy. |
| `policyResourceId` | string | The resource ID of the subscription policy. |
| `policyResourceName` | string | The resource name of the subscription policy. |

## Template references

- [Policies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Subscription/2021-10-01/policies)

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `policyId` | string | The object ID of the subscription policy. |
| `policyResourceId` | string | The resource ID of the subscription policy. |
| `policyResourceName` | string | The resource name of the subscription policy. |

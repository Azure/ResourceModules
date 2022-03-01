# Policy Exemptions on Subscription level `[Microsoft.Authorization/policyExemptions/subscription]`

With this module you can create policy exemptions on a subscription level.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyExemptions` | 2020-07-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string |  |  | Optional. The description of the policy exemption. |
| `displayName` | string |  |  | Optional. The display name of the policy exemption. Maximum length is 128 characters. |
| `exemptionCategory` | string | `Mitigated` | `[Mitigated, Waiver]` | Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated |
| `expiresOn` | string |  |  | Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z  |
| `metadata` | object | `{object}` |  | Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `name` | string |  |  | Required. Specifies the name of the policy exemption. Maximum length is 64 characters for subscription scope. |
| `policyAssignmentId` | string |  |  | Required. The resource ID of the policy assignment that is being exempted. |
| `policyDefinitionReferenceIds` | array | `[]` |  | Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition. |
| `subscriptionId` | string | `[subscription().subscriptionId]` |  | Optional. The subscription ID of the subscription to be exempted from the policy assignment. If not provided, will use the current scope for deployment. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Exemption Name |
| `resourceId` | string | Policy Exemption resource ID |
| `scope` | string | Policy Exemption Scope |

## Template references

- [Policyexemptions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-07-01-preview/policyExemptions)

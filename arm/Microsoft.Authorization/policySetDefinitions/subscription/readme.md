# Policy Set Definitions on Subscription level `[Microsoft.Authorization/policySetDefinitions/subscription]`

With this module you can create policy set definitions on a subscription level.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policySetDefinitions` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string |  |  | Optional. The description name of the Set Definition (Initiative) |
| `displayName` | string |  |  | Optional. The display name of the Set Definition (Initiative). Maximum length is 128 characters. |
| `metadata` | object | `{object}` |  | Optional. The Set Definition (Initiative) metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `name` | string |  |  | Required. Specifies the name of the policy Set Definition (Initiative). Maximum length is 64 characters for subscription scope. |
| `parameters` | object | `{object}` |  | Optional. The Set Definition (Initiative) parameters that can be used in policy definition references. |
| `policyDefinitionGroups` | array | `[]` |  | Optional. The metadata describing groups of policy definition references within the Policy Set Definition (Initiative). |
| `policyDefinitions` | array |  |  | Required. The array of Policy definitions object to include for this policy set. Each object must include the Policy definition ID, and optionally other properties like parameters |
| `subscriptionId` | string | `[subscription().subscriptionId]` |  | Optional. The subscription ID of the subscription |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Set Definition Name |
| `resourceId` | string | Policy Set Definition resource ID |

## Template references

- [Policysetdefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policySetDefinitions)

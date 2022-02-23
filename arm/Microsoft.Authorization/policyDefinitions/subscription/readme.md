# Policy Definitions on Subscription level `[Microsoft.Authorization/policyDefinitions/subscription]`

With this module you can create policy definitions on a subscription level.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyDefinitions` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string |  |  | Optional. The policy definition description. |
| `displayName` | string |  |  | Optional. The display name of the policy definition. Maximum length is 128 characters. |
| `metadata` | object | `{object}` |  | Optional. The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `mode` | string | `All` | `[All, Indexed, Microsoft.KeyVault.Data, Microsoft.ContainerService.Data, Microsoft.Kubernetes.Data]` | Optional. The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data. |
| `name` | string |  |  | Required. Specifies the name of the policy definition. Maximum length is 64 characters. |
| `parameters` | object | `{object}` |  | Optional. The policy definition parameters that can be used in policy definition references. |
| `policyRule` | object |  |  | Required. The Policy Rule details for the Policy Definition |
| `subscriptionId` | string | `[subscription().subscriptionId]` |  | Optional. The subscription ID of the subscription |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Definition Name |
| `resourceId` | string | Policy Definition resource ID |
| `roleDefinitionIds` | array | Policy Definition Role Definition IDs |

## Template references

- [Policydefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyDefinitions)

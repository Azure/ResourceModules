# Policy Definitions on Management Group level `[Microsoft.Authorization/policyDefinitions/managementGroups]`

With this module you can create policy definitions on a management group level.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyDefinitions` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string |  |  | Optional. The policy definition description. |
| `displayName` | string |  |  | Optional. The display name of the policy definition. |
| `managementGroupId` | string |  |  | Required. The group ID of the Management Group |
| `metadata` | object | `{object}` |  | Optional. The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `mode` | string | `All` | `[All, Indexed, Microsoft.KeyVault.Data, Microsoft.ContainerService.Data, Microsoft.Kubernetes.Data]` | Optional. The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data. |
| `name` | string |  |  | Required. Specifies the name of the policy definition. |
| `parameters` | object | `{object}` |  | Optional. The policy definition parameters that can be used in policy definition references. |
| `policyRule` | object |  |  | Required. The Policy Rule details for the Policy Definition |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Definition Name |
| `resourceId` | string | Policy Definition resource ID |
| `roleDefinitionIds` | array | Policy Definition Role Definition IDs |

## Template references

- [Policydefinitions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyDefinitions)

# Policy Assignment on Management Group level `[Microsoft.Authorization/policyAssignments/managementGroup]`

With this module you can perform policy assignments on a management group level.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyAssignments` | 2021-06-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string |  |  | Optional. This message will be part of response in case of policy violation. |
| `displayName` | string |  |  | Optional. The display name of the policy assignment. Maximum length is 128 characters. |
| `enforcementMode` | string | `Default` | `[Default, DoNotEnforce]` | Optional. The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce |
| `identity` | string | `SystemAssigned` | `[SystemAssigned, None]` | Optional. The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions. |
| `location` | string | `[deployment().location]` |  | Optional. Location for all resources. |
| `managementGroupId` | string | `[managementGroup().name]` |  | Optional. The Target Scope for the Policy. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment. |
| `metadata` | object | `{object}` |  | Optional. The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `name` | string |  |  | Required. Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope. |
| `nonComplianceMessage` | string |  |  | Optional. The messages that describe why a resource is non-compliant with the policy. |
| `notScopes` | array | `[]` |  | Optional. The policy excluded scopes |
| `parameters` | object | `{object}` |  | Optional. Parameters for the policy assignment if needed. |
| `policyDefinitionId` | string |  |  | Required. Specifies the ID of the policy definition or policy set definition being assigned. |
| `roleDefinitionIds` | array | `[]` |  | Required. The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Assignment Name |
| `principalId` | string | Policy Assignment principal ID |
| `resourceId` | string | Policy Assignment resource ID |

## Template references

- [Policyassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyAssignments)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

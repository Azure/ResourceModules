# Policy Assignment on Resource Group level `[Microsoft.Authorization/policyAssignments/resourceGroup]`

With this module you can perform policy assignments on a resource group level

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyAssignments` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the policy assignment. Maximum length is 64 characters for resource group scope. |
| `policyDefinitionId` | string | Specifies the ID of the policy definition or policy set definition being assigned. |
| `roleDefinitionIds` | array | The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `description` | string | `''` |  | This message will be part of response in case of policy violation. |
| `displayName` | string | `''` |  | The display name of the policy assignment. Maximum length is 128 characters. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enforcementMode` | string | `'Default'` | `[Default, DoNotEnforce]` | The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce. |
| `identity` | string | `'SystemAssigned'` | `[SystemAssigned, UserAssigned, None]` | The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `metadata` | object | `{object}` |  | The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| `nonComplianceMessage` | string | `''` |  | The messages that describe why a resource is non-compliant with the policy. |
| `notScopes` | array | `[]` |  | The policy excluded scopes. |
| `parameters` | object | `{object}` |  | Parameters for the policy assignment if needed. |
| `resourceGroupName` | string | `[resourceGroup().name]` |  | The Target Scope for the Policy. The name of the resource group for the policy assignment. If not provided, will use the current scope for deployment. |
| `subscriptionId` | string | `[subscription().subscriptionId]` |  | The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment. If not provided, will use the current scope for deployment. |
| `userAssignedIdentityId` | string | `''` |  | The Resource ID for the user assigned identity to assign to the policy assignment. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | Policy Assignment Name. |
| `principalId` | string | Policy Assignment principal ID. |
| `resourceGroupName` | string | The name of the resource group the policy was assigned to. |
| `resourceId` | string | Policy Assignment resource ID. |

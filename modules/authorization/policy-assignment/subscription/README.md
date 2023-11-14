# Policy Assignments (Subscription scope) `[Microsoft.Authorization/policyAssignments]`

This module deploys a Policy Assignment at a Subscription scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyAssignments` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-06-01/policyAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Specifies the name of the policy assignment. Maximum length is 64 characters for subscription scope. |
| [`policyDefinitionId`](#parameter-policydefinitionid) | string | Specifies the ID of the policy definition or policy set definition being assigned. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | This message will be part of response in case of policy violation. |
| [`displayName`](#parameter-displayname) | string | The display name of the policy assignment. Maximum length is 128 characters. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enforcementMode`](#parameter-enforcementmode) | string | The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce. |
| [`identity`](#parameter-identity) | string | The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`metadata`](#parameter-metadata) | object | The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| [`nonComplianceMessages`](#parameter-noncompliancemessages) | array | The messages that describe why a resource is non-compliant with the policy. |
| [`notScopes`](#parameter-notscopes) | array | The policy excluded scopes. |
| [`overrides`](#parameter-overrides) | array | The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition. |
| [`parameters`](#parameter-parameters) | object | Parameters for the policy assignment if needed. |
| [`resourceSelectors`](#parameter-resourceselectors) | array | The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location. |
| [`roleDefinitionIds`](#parameter-roledefinitionids) | array | The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition. |
| [`subscriptionId`](#parameter-subscriptionid) | string | The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment. If not provided, will use the current scope for deployment. |
| [`userAssignedIdentityId`](#parameter-userassignedidentityid) | string | The Resource ID for the user assigned identity to assign to the policy assignment. |

### Parameter: `description`

This message will be part of response in case of policy violation.
- Required: No
- Type: string
- Default: `''`

### Parameter: `displayName`

The display name of the policy assignment. Maximum length is 128 characters.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enforcementMode`

The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce.
- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'DoNotEnforce'
  ]
  ```

### Parameter: `identity`

The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions.
- Required: No
- Type: string
- Default: `'SystemAssigned'`
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
    'UserAssigned'
  ]
  ```

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `metadata`

The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `name`

Specifies the name of the policy assignment. Maximum length is 64 characters for subscription scope.
- Required: Yes
- Type: string

### Parameter: `nonComplianceMessages`

The messages that describe why a resource is non-compliant with the policy.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `notScopes`

The policy excluded scopes.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `overrides`

The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `parameters`

Parameters for the policy assignment if needed.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `policyDefinitionId`

Specifies the ID of the policy definition or policy set definition being assigned.
- Required: Yes
- Type: string

### Parameter: `resourceSelectors`

The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `roleDefinitionIds`

The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `subscriptionId`

The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment. If not provided, will use the current scope for deployment.
- Required: No
- Type: string
- Default: `[subscription().subscriptionId]`

### Parameter: `userAssignedIdentityId`

The Resource ID for the user assigned identity to assign to the policy assignment.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | Policy Assignment Name. |
| `principalId` | string | Policy Assignment principal ID. |
| `resourceId` | string | Policy Assignment resource ID. |

## Cross-referenced modules

_None_

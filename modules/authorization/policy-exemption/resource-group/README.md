# Policy Exemptions (Resource Group scope) `[Microsoft.Authorization/policyExemptions]`

This module deploys a Policy Exemption at a Resource Group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyExemptions` | [2022-07-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-07-01-preview/policyExemptions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Specifies the name of the policy exemption. Maximum length is 64 characters for resource group scope. |
| [`policyAssignmentId`](#parameter-policyassignmentid) | string | The resource ID of the policy assignment that is being exempted. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignmentScopeValidation`](#parameter-assignmentscopevalidation) | string | The option whether validate the exemption is at or under the assignment scope. |
| [`description`](#parameter-description) | string | The description of the policy exemption. |
| [`displayName`](#parameter-displayname) | string | The display name of the policy exemption. Maximum length is 128 characters. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`exemptionCategory`](#parameter-exemptioncategory) | string | The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated. |
| [`expiresOn`](#parameter-expireson) | string | The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z. |
| [`metadata`](#parameter-metadata) | object | The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| [`policyDefinitionReferenceIds`](#parameter-policydefinitionreferenceids) | array | The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition. |
| [`resourceSelectors`](#parameter-resourceselectors) | array | The resource selector list to filter policies by resource properties. |

### Parameter: `assignmentScopeValidation`

The option whether validate the exemption is at or under the assignment scope.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Default'
    'DoNotValidate'
  ]
  ```

### Parameter: `description`

The description of the policy exemption.
- Required: No
- Type: string
- Default: `''`

### Parameter: `displayName`

The display name of the policy exemption. Maximum length is 128 characters.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `exemptionCategory`

The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated.
- Required: No
- Type: string
- Default: `'Mitigated'`
- Allowed:
  ```Bicep
  [
    'Mitigated'
    'Waiver'
  ]
  ```

### Parameter: `expiresOn`

The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z.
- Required: No
- Type: string
- Default: `''`

### Parameter: `metadata`

The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `name`

Specifies the name of the policy exemption. Maximum length is 64 characters for resource group scope.
- Required: Yes
- Type: string

### Parameter: `policyAssignmentId`

The resource ID of the policy assignment that is being exempted.
- Required: Yes
- Type: string

### Parameter: `policyDefinitionReferenceIds`

The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `resourceSelectors`

The resource selector list to filter policies by resource properties.
- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Exemption Name. |
| `resourceGroupName` | string | The name of the resource group the policy exemption was applied at. |
| `resourceId` | string | Policy Exemption resource ID. |
| `scope` | string | Policy Exemption Scope. |

## Cross-referenced modules

_None_

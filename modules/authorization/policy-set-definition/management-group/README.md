# Policy Set Definitions (Initiatives) (Management Group scope) `[Microsoft.Authorization/policySetDefinitions]`

This module deploys a Policy Set Definition (Initiative) at a Management Group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policySetDefinitions` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policySetDefinitions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Specifies the name of the policy Set Definition (Initiative). |
| [`policyDefinitions`](#parameter-policydefinitions) | array | The array of Policy definitions object to include for this policy set. Each object must include the Policy definition ID, and optionally other properties like parameters. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The description name of the Set Definition (Initiative). |
| [`displayName`](#parameter-displayname) | string | The display name of the Set Definition (Initiative). Maximum length is 128 characters. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`metadata`](#parameter-metadata) | object | The Set Definition (Initiative) metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| [`parameters`](#parameter-parameters) | object | The Set Definition (Initiative) parameters that can be used in policy definition references. |
| [`policyDefinitionGroups`](#parameter-policydefinitiongroups) | array | The metadata describing groups of policy definition references within the Policy Set Definition (Initiative). |

### Parameter: `description`

The description name of the Set Definition (Initiative).
- Required: No
- Type: string
- Default: `''`

### Parameter: `displayName`

The display name of the Set Definition (Initiative). Maximum length is 128 characters.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location deployment metadata.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `metadata`

The Set Definition (Initiative) metadata. Metadata is an open ended object and is typically a collection of key-value pairs.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `name`

Specifies the name of the policy Set Definition (Initiative).
- Required: Yes
- Type: string

### Parameter: `parameters`

The Set Definition (Initiative) parameters that can be used in policy definition references.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `policyDefinitionGroups`

The metadata describing groups of policy definition references within the Policy Set Definition (Initiative).
- Required: No
- Type: array
- Default: `[]`

### Parameter: `policyDefinitions`

The array of Policy definitions object to include for this policy set. Each object must include the Policy definition ID, and optionally other properties like parameters.
- Required: Yes
- Type: array


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Set Definition Name. |
| `resourceId` | string | Policy Set Definition resource ID. |

## Cross-referenced modules

_None_

# Policy Definitions (Management Group scope) `[Microsoft.Authorization/policyDefinitions]`

This module deploys a Policy Definition at a Management Group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyDefinitions` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyDefinitions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Specifies the name of the policy definition. Maximum length is 64 characters. |
| [`policyRule`](#parameter-policyrule) | object | The Policy Rule details for the Policy Definition. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The policy definition description. |
| [`displayName`](#parameter-displayname) | string | The display name of the policy definition. Maximum length is 128 characters. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`metadata`](#parameter-metadata) | object | The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| [`mode`](#parameter-mode) | string | The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data. |
| [`parameters`](#parameter-parameters) | object | The policy definition parameters that can be used in policy definition references. |

### Parameter: `description`

The policy definition description.
- Required: No
- Type: string
- Default: `''`

### Parameter: `displayName`

The display name of the policy definition. Maximum length is 128 characters.
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

The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `mode`

The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data.
- Required: No
- Type: string
- Default: `'All'`
- Allowed:
  ```Bicep
  [
    'All'
    'Indexed'
    'Microsoft.ContainerService.Data'
    'Microsoft.KeyVault.Data'
    'Microsoft.Kubernetes.Data'
    'Microsoft.Network.Data'
  ]
  ```

### Parameter: `name`

Specifies the name of the policy definition. Maximum length is 64 characters.
- Required: Yes
- Type: string

### Parameter: `parameters`

The policy definition parameters that can be used in policy definition references.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `policyRule`

The Policy Rule details for the Policy Definition.
- Required: Yes
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Definition Name. |
| `resourceId` | string | Policy Definition resource ID. |
| `roleDefinitionIds` | array | Policy Definition Role Definition IDs. |

## Cross-referenced modules

_None_

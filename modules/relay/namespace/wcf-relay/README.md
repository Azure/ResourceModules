# Relay Namespace WCF Relays `[Microsoft.Relay/namespaces/wcfRelays]`

This module deploys a Relay Namespace WCF Relay.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Relay/namespaces/wcfRelays` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relay/2021-11-01/namespaces/wcfRelays) |
| `Microsoft.Relay/namespaces/wcfRelays/authorizationRules` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relay/2021-11-01/namespaces/wcfRelays/authorizationRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the WCF Relay. |
| [`relayType`](#parameter-relaytype) | string | Type of WCF Relay. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Relay Namespace for the WCF Relay. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationRules`](#parameter-authorizationrules) | array | Authorization Rules for the WCF Relay. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`requiresClientAuthorization`](#parameter-requiresclientauthorization) | bool | A value indicating if this relay requires client authorization. |
| [`requiresTransportSecurity`](#parameter-requirestransportsecurity) | bool | A value indicating if this relay requires transport security. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`userMetadata`](#parameter-usermetadata) | string | User-defined string data for the WCF Relay. |

### Parameter: `authorizationRules`

Authorization Rules for the WCF Relay.
- Required: No
- Type: array
- Default: `[System.Management.Automation.OrderedHashtable, System.Management.Automation.OrderedHashtable, System.Management.Automation.OrderedHashtable]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

Name of the WCF Relay.
- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent Relay Namespace for the WCF Relay. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `relayType`

Type of WCF Relay.
- Required: Yes
- Type: string
- Allowed: `[Http, NetTcp]`

### Parameter: `requiresClientAuthorization`

A value indicating if this relay requires client authorization.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `requiresTransportSecurity`

A value indicating if this relay requires transport security.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `userMetadata`

User-defined string data for the WCF Relay.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed wcf relay. |
| `resourceGroupName` | string | The resource group of the deployed wcf relay. |
| `resourceId` | string | The resource ID of the deployed wcf relay. |

## Cross-referenced modules

_None_

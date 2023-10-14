# Relay Namespace WCF Relays `[Microsoft.Relay/namespaces/wcfRelays]`

This module deploys a Relay Namespace WCF Relay.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Relay/namespaces/wcfRelays` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relay/2021-11-01/namespaces/wcfRelays) |
| `Microsoft.Relay/namespaces/wcfRelays/authorizationRules` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relay/2021-11-01/namespaces/wcfRelays/authorizationRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `name` | string |  | Name of the WCF Relay. |
| `relayType` | string | `[Http, NetTcp]` | Type of WCF Relay. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `namespaceName` | string | The name of the parent Relay Namespace for the WCF Relay. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | array | `[System.Management.Automation.OrderedHashtable, System.Management.Automation.OrderedHashtable, System.Management.Automation.OrderedHashtable]` |  | Authorization Rules for the WCF Relay. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `requiresClientAuthorization` | bool | `True` |  | A value indicating if this relay requires client authorization. |
| `requiresTransportSecurity` | bool | `True` |  | A value indicating if this relay requires transport security. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `userMetadata` | string | `''` |  | User-defined string data for the WCF Relay. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed wcf relay. |
| `resourceGroupName` | string | The resource group of the deployed wcf relay. |
| `resourceId` | string | The resource ID of the deployed wcf relay. |

## Cross-referenced modules

_None_

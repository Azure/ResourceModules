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
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`requiresClientAuthorization`](#parameter-requiresclientauthorization) | bool | A value indicating if this relay requires client authorization. |
| [`requiresTransportSecurity`](#parameter-requirestransportsecurity) | bool | A value indicating if this relay requires transport security. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`userMetadata`](#parameter-usermetadata) | string | User-defined string data for the WCF Relay. |

### Parameter: `authorizationRules`

Authorization Rules for the WCF Relay.
- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      name: 'RootManageSharedAccessKey'
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
    {
      name: 'defaultListener'
      rights: [
        'Listen'
      ]
    }
    {
      name: 'defaultSender'
      rights: [
        'Send'
      ]
    }
  ]
  ```

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `lock`

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

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
- Allowed:
  ```Bicep
  [
    'Http'
    'NetTcp'
  ]
  ```

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


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

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

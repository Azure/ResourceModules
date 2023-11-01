# Storage Account Blob Containers `[Microsoft.Storage/storageAccounts/blobServices/containers]`

This module deploys a Storage Account Blob Container.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the storage container to deploy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultEncryptionScope`](#parameter-defaultencryptionscope) | string | Default the container to use specified encryption scope for all writes. |
| [`denyEncryptionScopeOverride`](#parameter-denyencryptionscopeoverride) | bool | Block override of encryption scope from the container default. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enableNfsV3AllSquash`](#parameter-enablenfsv3allsquash) | bool | Enable NFSv3 all squash on blob container. |
| [`enableNfsV3RootSquash`](#parameter-enablenfsv3rootsquash) | bool | Enable NFSv3 root squash on blob container. |
| [`immutabilityPolicyName`](#parameter-immutabilitypolicyname) | string | Name of the immutable policy. |
| [`immutabilityPolicyProperties`](#parameter-immutabilitypolicyproperties) | object | Configure immutability policy. |
| [`immutableStorageWithVersioningEnabled`](#parameter-immutablestoragewithversioningenabled) | bool | This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process. |
| [`metadata`](#parameter-metadata) | object | A name-value pair to associate with the container as metadata. |
| [`publicAccess`](#parameter-publicaccess) | string | Specifies whether data in the container may be accessed publicly and the level of access. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

### Parameter: `defaultEncryptionScope`

Default the container to use specified encryption scope for all writes.
- Required: No
- Type: string
- Default: `''`

### Parameter: `denyEncryptionScopeOverride`

Block override of encryption scope from the container default.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableNfsV3AllSquash`

Enable NFSv3 all squash on blob container.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableNfsV3RootSquash`

Enable NFSv3 root squash on blob container.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `immutabilityPolicyName`

Name of the immutable policy.
- Required: No
- Type: string
- Default: `'default'`

### Parameter: `immutabilityPolicyProperties`

Configure immutability policy.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `immutableStorageWithVersioningEnabled`

This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `metadata`

A name-value pair to associate with the container as metadata.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `name`

The name of the storage container to deploy.
- Required: Yes
- Type: string

### Parameter: `publicAccess`

Specifies whether data in the container may be accessed publicly and the level of access.
- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'Blob'
    'Container'
    'None'
  ]
  ```

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

### Parameter: `storageAccountName`

The name of the parent Storage Account. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed container. |
| `resourceGroupName` | string | The resource group of the deployed container. |
| `resourceId` | string | The resource ID of the deployed container. |

## Cross-referenced modules

_None_

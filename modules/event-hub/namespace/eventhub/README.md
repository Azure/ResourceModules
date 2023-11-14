# Event Hub Namespace Event Hubs `[Microsoft.EventHub/namespaces/eventhubs]`

This module deploys an Event Hub Namespace Event Hub.

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
| `Microsoft.EventHub/namespaces/eventhubs` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/eventhubs) |
| `Microsoft.EventHub/namespaces/eventhubs/authorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/eventhubs/authorizationRules) |
| `Microsoft.EventHub/namespaces/eventhubs/consumergroups` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/eventhubs/consumergroups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the event hub. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationRules`](#parameter-authorizationrules) | array | Authorization Rules for the event hub. |
| [`captureDescriptionDestinationArchiveNameFormat`](#parameter-capturedescriptiondestinationarchivenameformat) | string | Blob naming convention for archive, e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order. |
| [`captureDescriptionDestinationBlobContainer`](#parameter-capturedescriptiondestinationblobcontainer) | string | Blob container Name. |
| [`captureDescriptionDestinationName`](#parameter-capturedescriptiondestinationname) | string | Name for capture destination. |
| [`captureDescriptionDestinationStorageAccountResourceId`](#parameter-capturedescriptiondestinationstorageaccountresourceid) | string | Resource ID of the storage account to be used to create the blobs. |
| [`captureDescriptionEnabled`](#parameter-capturedescriptionenabled) | bool | A value that indicates whether capture description is enabled. |
| [`captureDescriptionEncoding`](#parameter-capturedescriptionencoding) | string | Enumerates the possible values for the encoding format of capture description. Note: "AvroDeflate" will be deprecated in New API Version. |
| [`captureDescriptionIntervalInSeconds`](#parameter-capturedescriptionintervalinseconds) | int | The time window allows you to set the frequency with which the capture to Azure Blobs will happen. |
| [`captureDescriptionSizeLimitInBytes`](#parameter-capturedescriptionsizelimitinbytes) | int | The size window defines the amount of data built up in your Event Hub before an capture operation. |
| [`captureDescriptionSkipEmptyArchives`](#parameter-capturedescriptionskipemptyarchives) | bool | A value that indicates whether to Skip Empty Archives. |
| [`consumergroups`](#parameter-consumergroups) | array | The consumer groups to create in this event hub instance. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`messageRetentionInDays`](#parameter-messageretentionindays) | int | Number of days to retain the events for this Event Hub, value should be 1 to 7 days. Will be automatically set to infinite retention if cleanup policy is set to "Compact". |
| [`partitionCount`](#parameter-partitioncount) | int | Number of partitions created for the Event Hub, allowed values are from 1 to 32 partitions. |
| [`retentionDescriptionCleanupPolicy`](#parameter-retentiondescriptioncleanuppolicy) | string | Retention cleanup policy. Enumerates the possible values for cleanup policy. |
| [`retentionDescriptionRetentionTimeInHours`](#parameter-retentiondescriptionretentiontimeinhours) | int | Retention time in hours. Number of hours to retain the events for this Event Hub. This value is only used when cleanupPolicy is Delete. If cleanupPolicy is Compact the returned value of this property is Long.MaxValue. |
| [`retentionDescriptionTombstoneRetentionTimeInHours`](#parameter-retentiondescriptiontombstoneretentiontimeinhours) | int | Retention cleanup policy. Number of hours to retain the tombstone markers of a compacted Event Hub. This value is only used when cleanupPolicy is Compact. Consumer must complete reading the tombstone marker within this specified amount of time if consumer begins from starting offset to ensure they get a valid snapshot for the specific key described by the tombstone marker within the compacted Event Hub. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`status`](#parameter-status) | string | Enumerates the possible values for the status of the Event Hub. |

### Parameter: `authorizationRules`

Authorization Rules for the event hub.
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
  ]
  ```

### Parameter: `captureDescriptionDestinationArchiveNameFormat`

Blob naming convention for archive, e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order.
- Required: No
- Type: string
- Default: `'{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'`

### Parameter: `captureDescriptionDestinationBlobContainer`

Blob container Name.
- Required: No
- Type: string
- Default: `''`

### Parameter: `captureDescriptionDestinationName`

Name for capture destination.
- Required: No
- Type: string
- Default: `'EventHubArchive.AzureBlockBlob'`

### Parameter: `captureDescriptionDestinationStorageAccountResourceId`

Resource ID of the storage account to be used to create the blobs.
- Required: No
- Type: string
- Default: `''`

### Parameter: `captureDescriptionEnabled`

A value that indicates whether capture description is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `captureDescriptionEncoding`

Enumerates the possible values for the encoding format of capture description. Note: "AvroDeflate" will be deprecated in New API Version.
- Required: No
- Type: string
- Default: `'Avro'`
- Allowed:
  ```Bicep
  [
    'Avro'
    'AvroDeflate'
  ]
  ```

### Parameter: `captureDescriptionIntervalInSeconds`

The time window allows you to set the frequency with which the capture to Azure Blobs will happen.
- Required: No
- Type: int
- Default: `300`

### Parameter: `captureDescriptionSizeLimitInBytes`

The size window defines the amount of data built up in your Event Hub before an capture operation.
- Required: No
- Type: int
- Default: `314572800`

### Parameter: `captureDescriptionSkipEmptyArchives`

A value that indicates whether to Skip Empty Archives.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `consumergroups`

The consumer groups to create in this event hub instance.
- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      name: '$Default'
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

### Parameter: `messageRetentionInDays`

Number of days to retain the events for this Event Hub, value should be 1 to 7 days. Will be automatically set to infinite retention if cleanup policy is set to "Compact".
- Required: No
- Type: int
- Default: `1`

### Parameter: `name`

The name of the event hub.
- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent event hub namespace. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `partitionCount`

Number of partitions created for the Event Hub, allowed values are from 1 to 32 partitions.
- Required: No
- Type: int
- Default: `2`

### Parameter: `retentionDescriptionCleanupPolicy`

Retention cleanup policy. Enumerates the possible values for cleanup policy.
- Required: No
- Type: string
- Default: `'Delete'`
- Allowed:
  ```Bicep
  [
    'Compact'
    'Delete'
  ]
  ```

### Parameter: `retentionDescriptionRetentionTimeInHours`

Retention time in hours. Number of hours to retain the events for this Event Hub. This value is only used when cleanupPolicy is Delete. If cleanupPolicy is Compact the returned value of this property is Long.MaxValue.
- Required: No
- Type: int
- Default: `1`

### Parameter: `retentionDescriptionTombstoneRetentionTimeInHours`

Retention cleanup policy. Number of hours to retain the tombstone markers of a compacted Event Hub. This value is only used when cleanupPolicy is Compact. Consumer must complete reading the tombstone marker within this specified amount of time if consumer begins from starting offset to ensure they get a valid snapshot for the specific key described by the tombstone marker within the compacted Event Hub.
- Required: No
- Type: int
- Default: `1`

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

### Parameter: `status`

Enumerates the possible values for the status of the Event Hub.
- Required: No
- Type: string
- Default: `'Active'`
- Allowed:
  ```Bicep
  [
    'Active'
    'Creating'
    'Deleting'
    'Disabled'
    'ReceiveDisabled'
    'Renaming'
    'Restoring'
    'SendDisabled'
    'Unknown'
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `eventHubId` | string | The resource ID of the event hub. |
| `name` | string | The name of the event hub. |
| `resourceGroupName` | string | The resource group the event hub was deployed into. |
| `resourceId` | string | The authentication rule resource ID of the event hub. |

## Cross-referenced modules

_None_

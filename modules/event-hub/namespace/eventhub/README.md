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
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
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
- Default: `[System.Management.Automation.OrderedHashtable]`

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
- Allowed: `[Avro, AvroDeflate]`

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
- Default: `[System.Management.Automation.OrderedHashtable]`

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
- Allowed: `[Compact, Delete]`

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
- Default: `[]`

### Parameter: `status`

Enumerates the possible values for the status of the Event Hub.
- Required: No
- Type: string
- Default: `'Active'`
- Allowed: `[Active, Creating, Deleting, Disabled, ReceiveDisabled, Renaming, Restoring, SendDisabled, Unknown]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `eventHubId` | string | The resource ID of the event hub. |
| `name` | string | The name of the event hub. |
| `resourceGroupName` | string | The resource group the event hub was deployed into. |
| `resourceId` | string | The authentication rule resource ID of the event hub. |

## Cross-referenced modules

_None_

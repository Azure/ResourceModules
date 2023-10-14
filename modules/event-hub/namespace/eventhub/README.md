# Event Hub Namespace Event Hubs `[Microsoft.EventHub/namespaces/eventhubs]`

This module deploys an Event Hub Namespace Event Hub.

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
| `Microsoft.EventHub/namespaces/eventhubs` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/eventhubs) |
| `Microsoft.EventHub/namespaces/eventhubs/authorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/eventhubs/authorizationRules) |
| `Microsoft.EventHub/namespaces/eventhubs/consumergroups` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/eventhubs/consumergroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the event hub. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `namespaceName` | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | array | `[System.Management.Automation.OrderedHashtable]` |  | Authorization Rules for the event hub. |
| `captureDescriptionDestinationArchiveNameFormat` | string | `'{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'` |  | Blob naming convention for archive, e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order. |
| `captureDescriptionDestinationBlobContainer` | string | `''` |  | Blob container Name. |
| `captureDescriptionDestinationName` | string | `'EventHubArchive.AzureBlockBlob'` |  | Name for capture destination. |
| `captureDescriptionDestinationStorageAccountResourceId` | string | `''` |  | Resource ID of the storage account to be used to create the blobs. |
| `captureDescriptionEnabled` | bool | `False` |  | A value that indicates whether capture description is enabled. |
| `captureDescriptionEncoding` | string | `'Avro'` | `[Avro, AvroDeflate]` | Enumerates the possible values for the encoding format of capture description. Note: "AvroDeflate" will be deprecated in New API Version. |
| `captureDescriptionIntervalInSeconds` | int | `300` |  | The time window allows you to set the frequency with which the capture to Azure Blobs will happen. |
| `captureDescriptionSizeLimitInBytes` | int | `314572800` |  | The size window defines the amount of data built up in your Event Hub before an capture operation. |
| `captureDescriptionSkipEmptyArchives` | bool | `False` |  | A value that indicates whether to Skip Empty Archives. |
| `consumergroups` | array | `[System.Management.Automation.OrderedHashtable]` |  | The consumer groups to create in this event hub instance. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `messageRetentionInDays` | int | `1` |  | Number of days to retain the events for this Event Hub, value should be 1 to 7 days. Will be automatically set to infinite retention if cleanup policy is set to "Compact". |
| `partitionCount` | int | `2` |  | Number of partitions created for the Event Hub, allowed values are from 1 to 32 partitions. |
| `retentionDescriptionCleanupPolicy` | string | `'Delete'` | `[Compact, Delete]` | Retention cleanup policy. Enumerates the possible values for cleanup policy. |
| `retentionDescriptionRetentionTimeInHours` | int | `1` |  | Retention time in hours. Number of hours to retain the events for this Event Hub. This value is only used when cleanupPolicy is Delete. If cleanupPolicy is Compact the returned value of this property is Long.MaxValue. |
| `retentionDescriptionTombstoneRetentionTimeInHours` | int | `1` |  | Retention cleanup policy. Number of hours to retain the tombstone markers of a compacted Event Hub. This value is only used when cleanupPolicy is Compact. Consumer must complete reading the tombstone marker within this specified amount of time if consumer begins from starting offset to ensure they get a valid snapshot for the specific key described by the tombstone marker within the compacted Event Hub. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `status` | string | `'Active'` | `[Active, Creating, Deleting, Disabled, ReceiveDisabled, Renaming, Restoring, SendDisabled, Unknown]` | Enumerates the possible values for the status of the Event Hub. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `eventHubId` | string | The resource ID of the event hub. |
| `name` | string | The name of the event hub. |
| `resourceGroupName` | string | The resource group the event hub was deployed into. |
| `resourceId` | string | The authentication rule resource ID of the event hub. |

## Cross-referenced modules

_None_

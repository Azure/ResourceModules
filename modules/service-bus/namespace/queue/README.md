# Service Bus Namespace Queue `[Microsoft.ServiceBus/namespaces/queues]`

This module deploys a Service Bus Namespace Queue.

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
| `Microsoft.ServiceBus/namespaces/queues` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/queues) |
| `Microsoft.ServiceBus/namespaces/queues/authorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/queues/authorizationRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Service Bus Queue. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `namespaceName` | string | The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | array | `[System.Management.Automation.OrderedHashtable]` |  | Authorization Rules for the Service Bus Queue. |
| `autoDeleteOnIdle` | string | `''` |  | ISO 8061 timeSpan idle interval after which the queue is automatically deleted. The minimum duration is 5 minutes (PT5M). |
| `deadLetteringOnMessageExpiration` | bool | `True` |  | A value that indicates whether this queue has dead letter support when a message expires. |
| `defaultMessageTimeToLive` | string | `'P14D'` |  | ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
| `duplicateDetectionHistoryTimeWindow` | string | `'PT10M'` |  | ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes. |
| `enableBatchedOperations` | bool | `True` |  | Value that indicates whether server-side batched operations are enabled. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableExpress` | bool | `False` |  | A value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. |
| `enablePartitioning` | bool | `False` |  | A value that indicates whether the queue is to be partitioned across multiple message brokers. |
| `forwardDeadLetteredMessagesTo` | string | `''` |  | Queue/Topic name to forward the Dead Letter message. |
| `forwardTo` | string | `''` |  | Queue/Topic name to forward the messages. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `lockDuration` | string | `'PT1M'` |  | ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute. |
| `maxDeliveryCount` | int | `10` |  | The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10. |
| `maxMessageSizeInKilobytes` | int | `1024` |  | Maximum size (in KB) of the message payload that can be accepted by the queue. This property is only used in Premium today and default is 1024. |
| `maxSizeInMegabytes` | int | `1024` |  | The maximum size of the queue in megabytes, which is the size of memory allocated for the queue. Default is 1024. |
| `requiresDuplicateDetection` | bool | `False` |  | A value indicating if this queue requires duplicate detection. |
| `requiresSession` | bool | `False` |  | A value that indicates whether the queue supports the concept of sessions. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `status` | string | `'Active'` | `[Active, Creating, Deleting, Disabled, ReceiveDisabled, Renaming, Restoring, SendDisabled, Unknown]` | Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed queue. |
| `resourceGroupName` | string | The resource group of the deployed queue. |
| `resourceId` | string | The resource ID of the deployed queue. |

## Cross-referenced modules

_None_

# ServiceBusQueues `[Microsoft.ServiceBus/namespacesResources/queues]`

This module deploys Service Bus Queue.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.ServiceBus/namespaces/providers/queues/roleAssignments` | 2020-04-01-preview |
| `Microsoft.ServiceBus/namespaces/queues` | 2021-06-01-preview |
| `Microsoft.ServiceBus/namespaces/queues/authorizationRules` | 2017-04-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | array | `[System.Collections.Hashtable]` |  | Optional. Authorization Rules for the Service Bus Queue |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `deadLetteringOnMessageExpiration` | bool | `True` |  | Optional. A value that indicates whether this queue has dead letter support when a message expires. |
| `defaultMessageTimeToLive` | string | `P14D` |  | Optional. ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
| `duplicateDetectionHistoryTimeWindow` | string | `PT10M` |  | Optional. ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes. |
| `enableBatchedOperations` | bool | `True` |  | Optional. Value that indicates whether server-side batched operations are enabled. |
| `enableExpress` | bool |  |  | Optional. A value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. |
| `enablePartitioning` | bool |  |  | Optional. A value that indicates whether the queue is to be partitioned across multiple message brokers. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `lockDuration` | string | `PT1M` |  | Optional. ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute. |
| `maxDeliveryCount` | int | `10` |  | Optional. The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10. |
| `maxSizeInMegabytes` | int | `1024` |  | Optional. The maximum size of the queue in megabytes, which is the size of memory allocated for the queue. Default is 1024. |
| `namespaceName` | string |  |  | Required. Name of the parent Service Bus Namespace for the Service Bus Queue. |
| `queueName` | string |  |  | Required. Name of the Service Bus Queue. |
| `requiresDuplicateDetection` | bool |  |  | Optional. A value indicating if this queue requires duplicate detection. |
| `requiresSession` | bool |  |  | Optional. A value that indicates whether the queue supports the concept of sessions. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `status` | string | `Active` | `[Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown]` | Optional. Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown |

### Parameter Usage: `authorizationRules`

Default value:

```json
"authorizationRules": {
    "value": [
        {
            "name": "RootManageSharedAccessKey",
            "properties": {
                "rights": [
                    "Listen",
                    "Manage",
                    "Send"
                ]
            }
        }
    ]
}
```

Example for 2 authorization rules:

```json
"authorizationRules": {
    "value": [
        {
            "name": "RootManageSharedAccessKey",
            "properties": {
                "rights": [
                    "Listen",
                    "Manage",
                    "Send"
                ]
            }
        },
        {
            "name": "AnotherKey",
            "properties": {
                "rights": [
                    "Listen",
                    "Send"
                ]
            }
        }
    ]
}
```

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name | Type |
| :-- | :-- |
| `namespaceQueueName` | string |
| `namespaceQueueResourceGroup` | string |
| `namespaceQueueResourceId` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Namespaces/Queues](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces/queues)
- [Namespaces/Queues/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/queues/authorizationRules)

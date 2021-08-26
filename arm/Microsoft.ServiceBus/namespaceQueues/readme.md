# ServiceBusQueues

This module deploys Service Bus Queue.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `Microsoft.ServiceBus/namespaces/queues/authorizationRules` | 2017-04-01 |
| `Microsoft.ServiceBus/namespaces/queues/providers/roleAssignments` | 2018-09-01-preview |
| `Microsoft.ServiceBus/namespaces/queues` | 2017-04-01 |
| `providers/locks` | 2016-09-01 |

- Microsoft.ServiceBus/namespaces

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | array | Optional. Authorization Rules for the Service Bus Queue | System.Object[] |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `deadLetteringOnMessageExpiration` | bool | Optional. A value that indicates whether this queue has dead letter support when a message expires. | True |  |
| `defaultMessageTimeToLive` | string | Optional. ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. | P14D |  |
| `duplicateDetectionHistoryTimeWindow` | string | Optional. ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes. | PT10M |  |
| `enableBatchedOperations` | bool | Optional. Value that indicates whether server-side batched operations are enabled. | True |  |
| `enableExpress` | bool | Optional. A value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. | False |  |
| `enablePartitioning` | bool | Optional. A value that indicates whether the queue is to be partitioned across multiple message brokers. | False |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockDuration` | string | Optional. ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute. | PT1M |  |
| `lockForDeletion` | bool | Optional. Switch to lock Service Bus Queue from deletion. | False |  |
| `maxDeliveryCount` | int | Optional. The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10. | 10 |  |
| `maxSizeInMegabytes` | int | Optional. The maximum size of the queue in megabytes, which is the size of memory allocated for the queue. Default is 1024. | 1024 |  |
| `namespaceName` | string | Required. Name of the parent Service Bus Namespace for the Service Bus Queue. |  |  |
| `queueName` | string | Required. Name of the Service Bus Queue. |  |  |
| `requiresDuplicateDetection` | bool | Optional. A value indicating if this queue requires duplicate detection. | False |  |
| `requiresSession` | bool | Optional. A value that indicates whether the queue supports the concept of sessions. | False |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `status` | string | Optional. Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown | Active | System.Object[] |
| `tags` | object | Optional. Tags of the resource. |  |  |

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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `authRuleResourceId` | string | The Id of the authorization rule marked by the variable with the same name. |
| `namespaceConnectionString` | securestring | The connection string of the Service Bus Namespace |
| `namespaceName` | string | The Name of the Service Bus Namespace. |
| `namespaceResourceGroup` | string | The name of the Resource Group with the Service Bus Namespace. |
| `queueResourceId` | string | The Resource Id of the Service Bus Queue. |
| `sharedAccessPolicyPrimaryKey` | securestring | The shared access policy primary key for the Service Bus Namespace |

## Considerations

*N/A*

## Additional resources

- [About Service Bus Queue] (https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-queues-topics-subscriptions)
- [Microsoft.ServiceBus/namespaces/queues template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.servicebus/namespaces/queues)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)

# EventHub `[Microsoft.EventHub/namespaces/eventhubs]`

This module deploys an Event Hub.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.EventHub/namespaces/eventhubs` | 2021-06-01-preview |
| `Microsoft.EventHub/namespaces/eventhubs/authorizationRules` | 2021-06-01-preview |
| `Microsoft.EventHub/namespaces/eventhubs/consumergroups` | 2021-06-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | _[authorizationRules](authorizationRules/readme.md)_ array | `[System.Collections.Hashtable]` |  | Optional. Authorization Rules for the event hub |
| `captureDescriptionDestinationArchiveNameFormat` | string | `{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}` |  | Optional. Blob naming convention for archive, e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order |
| `captureDescriptionDestinationBlobContainer` | string |  |  | Optional. Blob container Name |
| `captureDescriptionDestinationName` | string | `EventHubArchive.AzureBlockBlob` |  | Optional. Name for capture destination |
| `captureDescriptionDestinationStorageAccountResourceId` | string |  |  | Optional. Resource ID of the storage account to be used to create the blobs |
| `captureDescriptionEnabled` | bool |  |  | Optional. A value that indicates whether capture description is enabled. |
| `captureDescriptionEncoding` | string | `Avro` | `[Avro, AvroDeflate]` | Optional. Enumerates the possible values for the encoding format of capture description. Note: "AvroDeflate" will be deprecated in New API Version |
| `captureDescriptionIntervalInSeconds` | int | `300` |  | Optional. The time window allows you to set the frequency with which the capture to Azure Blobs will happen |
| `captureDescriptionSizeLimitInBytes` | int | `314572800` |  | Optional. The size window defines the amount of data built up in your Event Hub before an capture operation |
| `captureDescriptionSkipEmptyArchives` | bool |  |  | Optional. A value that indicates whether to Skip Empty Archives |
| `consumerGroups` | _[consumerGroups](consumerGroups/readme.md)_ array | `[System.Collections.Hashtable]` |  | Optional. The consumer groups to create in this event hub instance |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `messageRetentionInDays` | int | `1` |  | Optional. Number of days to retain the events for this Event Hub, value should be 1 to 7 days |
| `name` | string |  |  | Required. The name of the event hub |
| `namespaceName` | string |  |  | Required. The name of the event hub namespace |
| `partitionCount` | int | `2` |  | Optional. Number of partitions created for the Event Hub, allowed values are from 1 to 32 partitions. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `status` | string | `Active` | `[Active, Creating, Deleting, Disabled, ReceiveDisabled, Renaming, Restoring, SendDisabled, Unknown]` | Optional. Enumerates the possible values for the status of the Event Hub. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `eventHubId` | string | The resource ID of the event hub. |
| `name` | string | The name of the event hub. |
| `resourceGroupName` | string | The resource group the event hub was deployed into. |
| `resourceId` | string | The authentication rule resource ID of the event hub. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Namespaces/Eventhubs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs)
- [Namespaces/Eventhubs/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs/authorizationRules)
- [Namespaces/Eventhubs/Consumergroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs/consumergroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

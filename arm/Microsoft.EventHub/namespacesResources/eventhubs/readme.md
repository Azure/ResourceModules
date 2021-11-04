# EventHubs `[Microsoft.EventHub/namespaces/eventhubs]`

This module deploys EventHub.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.EventHub/namespaces/eventhubs` | 2021-06-01-preview |
| `Microsoft.EventHub/namespaces/eventhubs/authorizationRules` | 2021-06-01-preview |
| `Microsoft.EventHub/namespaces/eventhubs/consumergroups` | 2021-06-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | array | `[System.Collections.Hashtable]` |  | Optional. Authorization Rules for the Event Hub |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `eventHubConfiguration` | object | `{object}` |  | Optional. Object to configure all properties of an Event Hub instance |
| `eventHubName` | string |  |  | Required. The name of the EventHub |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `namespaceName` | string |  |  | Required. The name of the EventHub namespace |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |

### Parameter Usage: `eventHubConfiguration`

Default value:

```json
"eventHubConfiguration": {
    "value": {
        "properties": {
            "messageRetentionInDays": 1,
            "partitionCount": 2,
            "status": "Active",
            "captureDescription": {
                "enabled": false,
                "encoding": "Avro",
                "intervalInSeconds": 300,
                "sizeLimitInBytes": 314572800,
                "destination": {
                    "name": "EventHubArchive.AzureBlockBlob",
                    "properties": {
                        "storageAccountResourceId": "",
                        "blobContainer": "eventhub",
                        "archiveNameFormat": "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
                    }
                },
                "skipEmptyArchives": true
            }
        },
        "consumerGroups": [
            {
                "name": "$Default"
            }
        ]
    }
}
```

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
| `authRuleResourceId` | string | The AuthRuleResourceId of the Event Hub. |
| `eventHubId` | string | The Resource ID of the Event Hub. |
| `eventhubName` | string | The Name of the Event Hub. |
| `eventHubResourceGroup` | string | The Resource Group Name of the Event Hub. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Namespaces/Eventhubs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs)
- [Namespaces/Eventhubs/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs/authorizationRules)
- [Namespaces/Eventhubs/Consumergroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs/consumergroups)

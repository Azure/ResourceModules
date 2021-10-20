# EventHubs

This module deploys EventHub. 

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.EventHub/namespaces/eventhubs`|2017-04-01|
|`Microsoft.EventHub/namespaces/eventhubs/consumergroups`|2017-04-01|
|`Microsoft.EventHub/namespaces/eventhubs/authorizationRules`|2017-04-01|
|`Microsoft.EventHub/namespaces/eventhubs/providers/locks`|2016-09-01|
|`Microsoft.EventHub/namespaces/eventhubs/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | array | Optional. Authorization Rules for the Event Hub | System.Object[] |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `eventHubConfiguration` | object | Optional. Object to configure all properties of an Event Hub instance | properties=; consumerGroups=System.Object[] |  |
| `eventHubName` | string | Required. The name of the EventHub |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Event Hub from deletion. | False |  |
| `namespaceName` | string | Required. The name of the EventHub namespace |  |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Tags of the resource. |  |  |

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
| `authRuleResourceId` | string | The Id of the authorization rule marked by the variable with the same name. |
| `eventHubId` | string | The Resource Id of the EventHub Namespace |
| `namespaceConnectionString` | securestring | The connection string of the EventHub Namespace |
| `namespaceName` | string | The Name of the EventHub Namespace |
| `namespaceResourceGroup` | string | The name of the Resource Group with the EventHub Namespace |
| `sharedAccessPolicyPrimaryKey` | securestring | The shared access policy primary key for the EventHub Namespace |

### Scripts

- There is no Scripts for this Module

## Considerations

- There is no deployment considerations for this Module

## Additional resources

- [Microsoft EventHub template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.eventhub/allversions)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)

# EventHub Namespace `[Microsoft.EventHub/namespaces]`

This module deploys an EventHub namespace

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.EventHub/namespaces` | 2021-06-01-preview |
| `Microsoft.EventHub/namespaces/authorizationRules` | 2017-04-01 |
| `Microsoft.EventHub/namespaces/disasterRecoveryConfigs` | 2017-04-01 |
| `Microsoft.EventHub/namespaces/eventhubs` | 2021-06-01-preview |
| `Microsoft.EventHub/namespaces/eventhubs/authorizationRules` | 2021-06-01-preview |
| `Microsoft.EventHub/namespaces/eventhubs/consumergroups` | 2021-06-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Network/privateEndpoints` | 2021-03-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | _[authorizationRules](authorizationRules/readme.md)_ array | `[System.Collections.Hashtable]` |  | Optional. Authorization Rules for the Event Hub namespace |
| `baseTime` | string | `[utcNow('u')]` |  | Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `disasterRecoveryConfig` | object | `{object}` |  | Optional. The disaster recovery config for this namespace |
| `eventHubs` | _[eventHubs](eventHubs/readme.md)_ array | `[]` |  | Optional. The event hubs to deploy into this namespace |
| `isAutoInflateEnabled` | bool |  |  | Optional. Switch to enable the Auto Inflate feature of Event Hub. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[ArchiveLogs, OperationalLogs, KafkaCoordinatorLogs, KafkaUserErrorLogs, EventHubVNetConnectionEvent, CustomerManagedKeyUserLogs, AutoScaleLogs]` | `[ArchiveLogs, OperationalLogs, KafkaCoordinatorLogs, KafkaUserErrorLogs, EventHubVNetConnectionEvent, CustomerManagedKeyUserLogs, AutoScaleLogs]` | Optional. The name of logs that will be streamed. |
| `maximumThroughputUnits` | int | `1` |  | Optional. Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Optional. The name of the event hub namespace. If no name is provided, then unique name will be created. |
| `networkAcls` | object | `{object}` |  | Optional. Service endpoint object information |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration Details for private endpoints. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `skuCapacity` | int | `1` |  | Optional. Event Hub lan scale-out capacity of the resource |
| `skuName` | string | `Standard` | `[Basic, Standard]` | Optional. event hub plan sku name |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `vNetId` | string |  |  | Optional. Virtual Network Id to lock down the Event Hub. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |
| `zoneRedundant` | bool |  |  | Optional. Switch to make the Event Hub Namespace zone redundant. |

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
| `namespace` | string |
| `namespaceConnectionString` | string |
| `namespaceResourceGroup` | string |
| `namespaceResourceId` | string |
| `sharedAccessPolicyPrimaryKey` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Namespaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces)
- [Namespaces/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2017-04-01/namespaces/authorizationRules)
- [Namespaces/Disasterrecoveryconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2017-04-01/namespaces/disasterRecoveryConfigs)
- [Namespaces/Eventhubs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs)
- [Namespaces/Eventhubs/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs/authorizationRules)
- [Namespaces/Eventhubs/Consumergroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs/consumergroups)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/privateEndpoints/privateDnsZoneGroups)

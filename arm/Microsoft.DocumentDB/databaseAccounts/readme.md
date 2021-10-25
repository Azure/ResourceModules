# Documentdb Database Accounts `[Microsoft.DocumentDB/databaseAccount]`

This module deploys a Documentdb database account and its child resources.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.DocumentDB/databaseAccounts` | 2021-06-15 |
| `Microsoft.DocumentDB/databaseAccounts/providers/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `databaseAccountName` | string |  |  | Required. Name of the Database Account |
| `databaseAccountOfferType` | string | `Standard` | `[Standard]` | Optional. The offer type for the Cosmos DB database account. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `locations` | array |  |  | Required. Locations enabled for the Cosmos DB account. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[DataPlaneRequests, MongoRequests, QueryRuntimeStatistics, PartitionKeyStatistics, PartitionKeyRUConsumption, ControlPlaneRequests, CassandraRequests, GremlinRequests, TableApiRequests]` | `[DataPlaneRequests, MongoRequests, QueryRuntimeStatistics, PartitionKeyStatistics, PartitionKeyRUConsumption, ControlPlaneRequests, CassandraRequests, GremlinRequests, TableApiRequests]` | Optional. The name of logs that will be streamed. |
| `managedServiceIdentity` | string | `None` | `[None, SystemAssigned, SystemAssigned, UserAssigned, UserAssigned]` | Optional. The type of identity used for the database account. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' (default) will remove any identities from the database account. |
| `metricsToEnable` | array | `[Requests]` | `[Requests]` | Optional. The name of metrics that will be streamed. |
| `mongodbDatabases` | array | `[]` |  | Optional. MongoDB Databases configurations |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sqlDatabases` | array | `[]` |  | Optional. SQL Databases configurations |
| `tags` | object | `{object}` |  | Optional. Tags of the Database Account resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. Mandatory if 'managedServiceIdentity' contains UserAssigned. The list of user identities associated with the database account. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

### Parameter Usage: `locations`

```json
"locations": {
    "value": [
      {
        "failoverPriority": 1,
        "isZoneRedundant": true,
        "locationName": "East US"
      }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `databaseAccountName` | string | The name of the database account. |
| `databaseAccountResourceGroup` | string | The name of the Resource Group the database account was created in. |
| `databaseAccountResourceId` | string | The Resource Id of the database account. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Databaseaccounts](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-06-15/databaseAccounts)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)

# Event Grid System Topics `[Microsoft.EventGrid/systemTopics]`

This module deploys an Event Grid System Topic.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.EventGrid/systemTopics` | [2021-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2021-12-01/systemTopics) |
| `Microsoft.EventGrid/systemTopics/eventSubscriptions` | [2022-06-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2022-06-15/systemTopics/eventSubscriptions) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Event Grid Topic. |
| `source` | string | Source for the system topic. |
| `topicType` | string | TopicType for the system topic. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, DeliveryFailures]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `eventSubscriptions` | array | `[]` |  | Event subscriptions to deploy. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the event grid system topic. |
| `resourceGroupName` | string | The name of the resource group the event grid system topic was deployed into. |
| `resourceId` | string | The resource ID of the event grid system topic. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module systemTopic './event-grid/system-topic/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-egstcom'
  params: {
    // Required parameters
    name: 'egstcom001'
    source: '<source>'
    topicType: 'Microsoft.Storage.StorageAccounts'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    eventSubscriptions: [
      {
        destination: {
          endpointType: 'StorageQueue'
          properties: {
            queueMessageTimeToLiveInSeconds: 86400
            queueName: '<queueName>'
            resourceId: '<resourceId>'
          }
        }
        enableDefaultTelemetry: '<enableDefaultTelemetry>'
        eventDeliverySchema: 'CloudEventSchemaV1_0'
        expirationTimeUtc: '2099-01-01T11:00:21.715Z'
        filter: {
          enableAdvancedFilteringOnArrays: true
          isSubjectCaseSensitive: false
        }
        name: 'egstcom001'
        retryPolicy: {
          eventTimeToLive: '120'
          maxDeliveryAttempts: 10
        }
      }
    ]
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "egstcom001"
    },
    "source": {
      "value": "<source>"
    },
    "topicType": {
      "value": "Microsoft.Storage.StorageAccounts"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "eventSubscriptions": {
      "value": [
        {
          "destination": {
            "endpointType": "StorageQueue",
            "properties": {
              "queueMessageTimeToLiveInSeconds": 86400,
              "queueName": "<queueName>",
              "resourceId": "<resourceId>"
            }
          },
          "enableDefaultTelemetry": "<enableDefaultTelemetry>",
          "eventDeliverySchema": "CloudEventSchemaV1_0",
          "expirationTimeUtc": "2099-01-01T11:00:21.715Z",
          "filter": {
            "enableAdvancedFilteringOnArrays": true,
            "isSubjectCaseSensitive": false
          },
          "name": "egstcom001",
          "retryPolicy": {
            "eventTimeToLive": "120",
            "maxDeliveryAttempts": 10
          }
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module systemTopic './event-grid/system-topic/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-egstmin'
  params: {
    // Required parameters
    name: 'egstmin001'
    source: '<source>'
    topicType: 'Microsoft.Storage.StorageAccounts'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "egstmin001"
    },
    "source": {
      "value": "<source>"
    },
    "topicType": {
      "value": "Microsoft.Storage.StorageAccounts"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

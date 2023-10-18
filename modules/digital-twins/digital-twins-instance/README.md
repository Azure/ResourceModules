# Digital Twins Instances `[Microsoft.DigitalTwins/digitalTwinsInstances]`

This module deploys an Azure Digital Twins Instance.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DigitalTwins/digitalTwinsInstances` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DigitalTwins/2023-01-31/digitalTwinsInstances) |
| `Microsoft.DigitalTwins/digitalTwinsInstances/endpoints` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DigitalTwins/2023-01-31/digitalTwinsInstances/endpoints) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/digital-twins.digital-twins-instance:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module digitalTwinsInstance 'br:bicep/modules/digital-twins.digital-twins-instance:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dtdticom'
  params: {
    // Required parameters
    name: 'dtdticom001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    eventGridEndpoint: {
      eventGridDomainId: '<eventGridDomainId>'
      topicEndpoint: '<topicEndpoint>'
    }
    eventHubEndpoint: {
      authenticationType: 'IdentityBased'
      endpointUri: '<endpointUri>'
      entityPath: '<entityPath>'
      userAssignedIdentity: '<userAssignedIdentity>'
    }
    lock: 'CanNotDelete'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'API'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalResourceId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    serviceBusEndpoint: {
      authenticationType: 'IdentityBased'
      endpointUri: '<endpointUri>'
      entityPath: '<entityPath>'
      userAssignedIdentity: '<userAssignedIdentity>'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
      "value": "dtdticom001"
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
    "eventGridEndpoint": {
      "value": {
        "eventGridDomainId": "<eventGridDomainId>",
        "topicEndpoint": "<topicEndpoint>"
      }
    },
    "eventHubEndpoint": {
      "value": {
        "authenticationType": "IdentityBased",
        "endpointUri": "<endpointUri>",
        "entityPath": "<entityPath>",
        "userAssignedIdentity": "<userAssignedIdentity>"
      }
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "API",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalResourceId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "serviceBusEndpoint": {
      "value": {
        "authenticationType": "IdentityBased",
        "endpointUri": "<endpointUri>",
        "entityPath": "<entityPath>",
        "userAssignedIdentity": "<userAssignedIdentity>"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module digitalTwinsInstance 'br:bicep/modules/digital-twins.digital-twins-instance:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dtdtimin'
  params: {
    // Required parameters
    name: 'dtdtimin001'
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
      "value": "dtdtimin001"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Digital Twin Instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`eventGridEndpoint`](#parameter-eventgridendpoint) | object | Event Grid Endpoint. |
| [`eventHubEndpoint`](#parameter-eventhubendpoint) | object | Event Hub Endpoint. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`serviceBusEndpoint`](#parameter-servicebusendpoint) | object | Service Bus Endpoint. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, DataHistoryOperation, DigitalTwinsOperation, EventRoutesOperation, ModelsOperation, QueryOperation, ResourceProviderOperation]`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[AllMetrics]`
- Allowed: `[AllMetrics]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed.
- Required: No
- Type: string
- Default: `[format('{0}-diagnosticSettings', parameters('name'))]`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `eventGridEndpoint`

Event Grid Endpoint.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `eventHubEndpoint`

Event Hub Endpoint.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

The name of the Digital Twin Instance.
- Required: Yes
- Type: string

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Disabled, Enabled]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `serviceBusEndpoint`

Service Bus Endpoint.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Resource tags.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `hostname` | string | The hostname of the Digital Twins Instance. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Digital Twins Instance. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the Digital Twins Instance. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |

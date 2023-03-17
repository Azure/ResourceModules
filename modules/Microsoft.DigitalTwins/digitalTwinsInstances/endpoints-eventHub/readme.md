# DigitalTwin Instance Endpoint `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints-eventHub]`

This module deploys Digital Twin Instance Endpoints.

## Navigation

- [DigitalTwin Instance Endpoint `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints-eventHub]`](#digitaltwin-instance-endpoint-microsoftdigitaltwinsdigitaltwinsinstancesendpoints-eventhub)
  - [Navigation](#navigation)
  - [Resource Types](#resource-types)
  - [Parameters](#parameters)
    - [Parameter Usage: `eventhubEndpoint`](#parameter-usage-eventhubendpoint)
  - [Outputs](#outputs)
  - [Cross-referenced modules](#cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DigitalTwins/digitalTwinsInstances/endpoints` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DigitalTwins/2022-10-31/digitalTwinsInstances/endpoints) |

## Parameters

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `digitalTwinInstanceName` | string | The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `authenticationType` | string | `'KeyBased'` | Specifies the authentication type being used for connecting to the endpoint. If 'KeyBased' is selected, a connection string must be specified (at least the primary connection string). If 'IdentityBased' is selected, the endpointUri and entityPath properties must be specified. |
| `connectionStringPrimaryKey` | securestring | `''` | PrimaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. |
| `connectionStringSecondaryKey` | securestring | `''` | SecondaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. |
| `deadLetterSecret` | securestring | `''` | Dead letter storage secret for key-based authentication. Will be obfuscated during read. |
| `deadLetterUri` | string | `''` | Dead letter storage URL for identity-based authentication. |
| `enableDefaultTelemetry` | bool | `true` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `endpointUri` | string | `''` | The URL of the EventHub namespace for identity-based authentication. It must include the protocol 'sb://'. |
| `entityPath` | string | `''` | The EventHub name in the EventHub namespace for identity-based authentication. |
| `name` | string | `'EventHubEndpoint'` | The name of the Digital Twin Endpoint. |
| `systemAssignedIdentity` | string | `false` | Enables system assigned managed identity on the resource. |
| `userAssignedIdentity` | string | `''` | The ID to assign to the resource. |

### Parameter Usage: `eventhubEndpoint`

<details>

<summary>Parameter JSON format</summary>

```json
        "eventhubEndpoint": {
            "value": {
              "authenticationType": "IdentityBased", // IdentityBased or KeyBased
              "name": "<Endpoint Name>",
              "entityPath": "evh1", // Event Hub Name
              "endpointUri": "sb://xyz.servicebus.windows.net", //Event Hub namespace, including sb://
              "deadLetterUri": "",
              "deadLetterSecret": "",
              "connectionStringPrimaryKey": "", //Keybased Auth
              "connectionStringSecondaryKey": "" //Keybased Auth
            }
        }
```

</details>
<p>

<details>

<summary>Bicep format</summary>

```bicep
  eventhubEndpoint: {
    authenticationType: 'IdentityBased' // IdentityBased or KeyBased
    name: '<Endpoint Name>'
    entityPath: 'evh1' // Event Hub Name
    endpointUri: 'sb://xyz.servicebus.windows.net' //Event Hub namespace, including sb://
    deadLetterUri: ''
    deadLetterSecret: ''
    connectionStringPrimaryKey: '' //Keybased Auth
    connectionStringSecondaryKey: '' //Keybased Auth
  }
  ```

</details>
<p>





## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Endpoint. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the Endpoint. |

## Cross-referenced modules

_None_

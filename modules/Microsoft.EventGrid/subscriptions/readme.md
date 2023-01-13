# EventGrid EventSubscriptions `[Microsoft.EventGrid/subscriptions]`

This module deploys EventGrid EventSubscriptions.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventGrid/eventSubscriptions` | [2022-06-15](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2022-06-15/eventSubscriptions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `destination` | object | The destination for the event subscription. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#eventsubscriptiondestination-objects for more information). |
| `eventGridTopicName` | string | Name of the Event Grid Topic. |
| `name` | string | The name of the Event Grid Topic. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `deadLetterDestination` | object | `{object}` | Dead Letter Destination. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterdestination-objects for more information). |
| `deadLetterWithResourceIdentity` | object | `{object}` | Dead Letter with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterwithresourceidentity-objects for more information). |
| `deliveryWithResourceIdentity` | object | `{object}` | Delivery with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deliverywithresourceidentity-objects for more information). |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `eventDeliverySchema` | string | `'EventGridSchema'` | The event delivery schema for the event subscription. |
| `expirationTimeUtc` | string | `''` | The expiration time for the event subscription. |
| `filter` | object | `{object}` | The filter for the event subscription. |
| `labels` | array | `[]` | The list of user defined labels. |
| `location` | string | `[resourceGroup().location]` | Location for all Resources. |
| `retryPolicy` | object | `{object}` | Configuration of the retry Policy. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the event grid topic. |
| `resourceGroupName` | string | The name of the resource group the event grid topic was deployed into. |
| `resourceId` | string | The resource ID of the event grid topic. |

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
module subscriptions './Microsoft.EventGrid/subscriptions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-egescom'
  params: {
    // Required parameters
    destination: {
      endpointType: 'ServiceBusTopic'
      properties: {
        resourceId: '<resourceId>'
      }
    }
    eventGridTopicName: '<eventGridTopicName>'
    name: '<<namePrefix>>egescom001'
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
    "destination": {
      "value": {
        "endpointType": "ServiceBusTopic",
        "properties": {
          "resourceId": "<resourceId>"
        }
      }
    },
    "eventGridTopicName": {
      "value": "<eventGridTopicName>"
    },
    "name": {
      "value": "<<namePrefix>>egescom001"
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

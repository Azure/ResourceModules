# Event Grid System Topic Event Subscriptions `[Microsoft.EventGrid/systemTopics/eventSubscriptions]`

This module deploys an Event Grid System Topic Event Subscription.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventGrid/systemTopics/eventSubscriptions` | [2022-06-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2022-06-15/systemTopics/eventSubscriptions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `destination` | object | The destination for the event subscription. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#eventsubscriptiondestination-objects for more information). |
| `name` | string | The name of the Event Subscription. |
| `systemTopicName` | string | Name of the Event Grid System Topic. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `deadLetterDestination` | object | `{object}` |  | Dead Letter Destination. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterdestination-objects for more information). |
| `deadLetterWithResourceIdentity` | object | `{object}` |  | Dead Letter with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterwithresourceidentity-objects for more information). |
| `deliveryWithResourceIdentity` | object | `{object}` |  | Delivery with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deliverywithresourceidentity-objects for more information). |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `eventDeliverySchema` | string | `'EventGridSchema'` | `[CloudEventSchemaV1_0, CustomInputSchema, EventGridEvent, EventGridSchema]` | The event delivery schema for the event subscription. |
| `expirationTimeUtc` | string | `''` |  | The expiration time for the event subscription. Format is ISO-8601 (yyyy-MM-ddTHH:mm:ssZ). |
| `filter` | object | `{object}` |  | The filter for the event subscription. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#eventsubscriptionfilter for more information). |
| `labels` | array | `[]` |  | The list of user defined labels. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `retryPolicy` | object | `{object}` |  | The retry policy for events. This can be used to configure the TTL and maximum number of delivery attempts and time to live for events. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the event subscription. |
| `resourceGroupName` | string | The name of the resource group the event subscription was deployed into. |
| `resourceId` | string | The resource ID of the event subscription. |

## Cross-referenced modules

_None_

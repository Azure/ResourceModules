# DigitalTwin Instance Endpoint `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints-eventGrid]`

This module deploys Digital Twin Instance Endpoints.

## Navigation

- [DigitalTwin Instance Endpoint `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints-eventGrid]`](#digitaltwin-instance-endpoint-microsoftdigitaltwinsdigitaltwinsinstancesendpoints-eventgrid)
  - [Navigation](#navigation)
  - [Resource Types](#resource-types)
  - [Parameters](#parameters)
  - [Outputs](#outputs)
  - [Cross-referenced modules](#cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DigitalTwins/digitalTwinsInstances/endpoints` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DigitalTwins/2022-10-31/digitalTwinsInstances/endpoints) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `topicEndpoint` | string | EventGrid Topic Endpoint. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `digitalTwinInstanceName` | string | The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `accessKey1` | securestring | `''` | EventGrid secondary accesskey. Will be obfuscated during read. |
| `accessKey2` | securestring | `''` | EventGrid secondary accesskey. Will be obfuscated during read. |
| `eventGridDomainId` | string | N/A | Required. Event Grid Resource Id. |
| `topicEndpoint` | string | N/A |Required. EventGrid Topic Endpoint. |
| `eventGridDomainName` | string | N/A | Required. The resource name of the Event Grid Domain. |
| `deadLetterSecret` | securestring | `''` | Dead letter storage secret for key-based authentication. Will be obfuscated during read. |
| `deadLetterUri` | string | `''` | Dead letter storage URL for identity-based authentication. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `'EventGridEndpoint'` | The name of the Digital Twin Endpoint. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Endpoint. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the Endpoint. |

## Cross-referenced modules

_None_

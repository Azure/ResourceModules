# DigitalTwin Instance Event Grid Endpoint `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints]`

This module deploys Digital Twin Instance Endpoints.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DigitalTwins/digitalTwinsInstances/endpoints` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DigitalTwins/2023-01-31/digitalTwinsInstances/endpoints) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `eventGridDomainResourceId` | string | The resource ID of the Event Grid to get access keys from. |
| `topicEndpoint` | string | EventGrid Topic Endpoint. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `digitalTwinInstanceName` | string | The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
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

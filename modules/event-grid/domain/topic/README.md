# Event Grid Domain Topics `[Microsoft.EventGrid/domains/topics]`

This module deploys an Event Grid Domain Topic.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventGrid/domains/topics` | [2022-06-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2022-06-15/domains/topics) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Event Grid Domain Topic. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `domainName` | string | The name of the parent Event Grid Domain. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all Resources. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the event grid topic. |
| `resourceGroupName` | string | The name of the resource group the event grid topic was deployed into. |
| `resourceId` | string | The resource ID of the event grid topic. |

## Cross-referenced modules

_None_

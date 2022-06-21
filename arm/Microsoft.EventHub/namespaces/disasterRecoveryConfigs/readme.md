# EventHub Namespace Disaster Recovery Config `[Microsoft.EventHub/namespaces/disasterRecoveryConfigs]`

This module deploys an EventHub Namespace Disaster Recovery Config

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventHub/namespaces/disasterRecoveryConfigs` | [2021-11-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-11-01/namespaces/disasterRecoveryConfigs) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the disaster recovery config. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `namespaceName` | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `partnerNamespaceId` | string | `''` | Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the disaster recovery config. |
| `resourceGroupName` | string | The name of the resource group the disaster recovery config was created in. |
| `resourceId` | string | The resource ID of the disaster recovery config. |

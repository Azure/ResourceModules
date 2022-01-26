# Service Bus Namespace Disaster Recovery Config `[Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs]`

This module deploys a disaster recovery config for a service bus Namespace

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs` | 2017-04-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `alternateName` | string |  |  | Optional. Primary/Secondary eventhub namespace name, which is part of GEO DR pairing |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string | `default` |  | Optional. The name of the disaster recovery config |
| `namespaceName` | string |  |  | Required. Name of the parent Service Bus Namespace for the Service Bus Queue. |
| `partnerNamespaceResourceID` | string |  |  | Optional. Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the disaster recovery config. |
| `resourceGroupName` | string | The name of the Resource Group the disaster recovery config was created in. |
| `resourceId` | string | The Resource ID of the disaster recovery config. |

## Template references

- [Namespaces/Disasterrecoveryconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/disasterRecoveryConfigs)

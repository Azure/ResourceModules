# ServicebusNamespacesDisasterrecoveryconfigs `[Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs]`

// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs` | 2017-04-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `alternateName` | string |  |  | Optional. Primary/Secondary eventhub namespace name, which is part of GEO DR pairing |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `name` | string | `default` |  | Optional. The name of the disaster recovery config |
| `namespaceName` | string |  |  | Required. Name of the parent Service Bus Namespace for the Service Bus Queue. |
| `partnerNamespace` | string |  |  | Optional. ARM Id of the Primary/Secondary eventhub namespace name, which is part of GEO DR pairing |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `disasterRecoveryConfigName` | string | The name of the disaster recovery config. |
| `disasterRecoveryConfigResourceGroup` | string | The name of the Resource Group the disaster recovery config was created in. |
| `disasterRecoveryConfigResourceId` | string | The Resource Id of the disaster recovery config. |

## Template references

- [Namespaces/Disasterrecoveryconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/disasterRecoveryConfigs)

# Data Factory Integration RunTimes `[Microsoft.DataFactory/factories/integrationRuntime]`

This module deploys a Managed or Self-Hosted Integration Runtime for an Azure Data Factory

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `dataFactoryName` | string |  | The name of the Azure Data Factory |
| `name` | string |  | The name of the Integration Runtime |
| `type` | string | `[Managed, SelfHosted]` | The type of Integration Runtime |
| `typeProperties` | object |  | Integration Runtime type properties. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `managedVirtualNetworkName` | string | `''` | The name of the Managed Virtual Network if using type "Managed"  |


### Parameter Usage: [`typeProperties`](https://docs.microsoft.com/en-us/azure/templates/microsoft.datafactory/factories/integrationruntimes?tabs=bicep#integrationruntime-objects)

```json
"typeProperties": {
    "value": {
        "computeProperties": {
            "location": "AutoResolve"
        }
    }
}

```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Integration Runtime. |
| `resourceGroupName` | string | The name of the Resource Group the Integration Runtime was created in. |
| `resourceId` | string | The resource ID of the Integration Runtime. |

## Template references

- [Factories/Integrationruntimes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes)

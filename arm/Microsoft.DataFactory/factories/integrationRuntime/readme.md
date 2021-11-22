# Data Factory Integration RunTimes `[Microsoft.DataFactory/factories/integrationRuntimes]`

This module deployes a Managed or Self-Hosted Integration Runtime for an Azure Data Factory
## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered|
| `name` | string |  |  | Required. The name of the Integration Runtime. |
| `dataFactoryName` | string |  |  | Required. The name of the Azure Data Factory |
| `type` | string |  | `[Managed, Self-Hosted]`  | Required. The type of Integration Runtime |
| `managedVirtualNetworkName` | string |  |  | Optional. The name of the Managed Virtual Network if using type "Managed". |
| `typeProperties` | object |  |  | Required. Integration runtime type properties. |

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
| `integrationRuntimeResourceGroup` | string | The name of the Resource Group the Integration Runtime was created in. |
| `integrationRuntimeName` | string | The name of the Integration Runtime. |
| `integrationRuntimeId` | string | The ID of the Integration Runtime. |

## Template references

- [Factories/Integrationruntimes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes)

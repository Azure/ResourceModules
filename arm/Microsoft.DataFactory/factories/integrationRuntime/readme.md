# Data Factory Integration RunTimes `[Microsoft.DataFactory/factories/integrationRuntime]`

This module deploys a Managed or Self-Hosted Integration Runtime for an Azure Data Factory

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `dataFactoryName` | string |  |  | Required. The name of the Azure Data Factory |
| `managedVirtualNetworkName` | string |  |  | Optional. The name of the Managed Virtual Network if using type "Managed"  |
| `name` | string |  |  | Required. The name of the Integration Runtime |
| `type` | string |  | `[Managed, SelfHosted]` | Required. The type of Integration Runtime |
| `typeProperties` | object |  |  | Required. Integration Runtime type properties. |

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

# DataFactoryIntegrationRunTimes `[Microsoft.DataFactory/factories/integrationRuntimes]`

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered|
| `name` | string |  |  | Required. The name of the Integration Runtime. |
| `dataFactoryName` | string |  |  | Required. The name of the Azure Factory to create |
| `managedVirtualNetworkName` | string |  |  | Required. The name of the Managed Virtual Network. |
| `typeProperties` | object |  |  | Required. Managed integration runtime type properties. |

### Parameter Usage: `typeProperties`

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
| `integrationRuntimeId` | string | The id of the Integration Runtime. |

## Template references

- [Factories/Integrationruntimes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes)

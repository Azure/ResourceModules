# DataFactoryIntegrationRunTimes `[Microsoft.DataFactory/factories/integrationRuntimes]`

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered|
| `dataFactoryName` | string |  |  | Required. The name of the Azure Factory to create |
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

## Template references

- [Factories/Integrationruntimes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes)

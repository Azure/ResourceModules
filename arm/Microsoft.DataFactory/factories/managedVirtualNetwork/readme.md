# DataFactoryManagedVirtualNetwork `[Microsoft.DataFactory/factories/managedVirtualNetworks]`

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/managedVirtualNetworks` | 2018-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `dataFactoryName` | string |  |  | Required. The name of the Azure Factory to create |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `managedVirtualNetworkResourceGroup` | string | The name of the Resource Group the Managed Virtual Network was created in. |

## Template references

- [Factories/Managedvirtualnetworks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks)

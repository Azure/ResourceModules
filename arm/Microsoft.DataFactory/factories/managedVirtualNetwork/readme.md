# Data Factory Managed Virtual Network `[Microsoft.DataFactory/factories/managedVirtualNetworks]`

This module deploys a Managed Virtual Network for an Azure Data Factory

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/managedVirtualNetworks` | 2018-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `dataFactoryName` | string |  |  | Required. The name of the Azure Factory|
| `name` | string |  |  | Required. The name of the Managed Virtual Network|
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `managedVirtualNetworkResourceGroup` | string | The name of the Resource Group the Managed Virtual Network was created in. |
| `managedVirtualNetworkName` | string | The name of the Managed Virtual Network.|
| `managedVirtualNetworkId` | string | The resource ID of the Managed Virtual Network.|

## Template references

- [Factories/Managedvirtualnetworks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks)

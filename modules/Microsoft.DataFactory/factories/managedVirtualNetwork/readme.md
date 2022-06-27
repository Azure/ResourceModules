# Data Factory Managed Virtual Network `[Microsoft.DataFactory/factories/managedVirtualNetwork]`

This module deploys a Managed Virtual Network for an Azure Data Factory

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/managedVirtualNetworks` | [2018-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Managed Virtual Network. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `dataFactoryName` | string | The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Managed Virtual Network. |
| `resourceGroupName` | string | The name of the Resource Group the Managed Virtual Network was created in. |
| `resourceId` | string | The resource ID of the Managed Virtual Network. |

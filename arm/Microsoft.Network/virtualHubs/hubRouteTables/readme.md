# Virtual Hub Route Table `[Microsoft.Network/virtualHubs/hubRouteTables]`

This module deploys virtual hub route tables.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualHubs/hubRouteTables` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The route table name. |
| `virtualHubName` | string | The virtual hub name. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `labels` | array | `[]` | List of labels associated with this route table. |
| `routes` | array | `[]` | List of all routes. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed virtual hub route table |
| `resourceGroupName` | string | The resource group the virtual hub route table was deployed into |
| `resourceId` | string | The resource ID of the deployed virtual hub route table |

## Template references

- [Virtualhubs/Hubroutetables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualHubs/hubRouteTables)

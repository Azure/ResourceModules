# Virtual Hub Route Table `[Microsoft.Network/virtualHubs/hubRouteTables]`

This module deploys virtual hub route tables.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualHubs/hubRouteTables` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `labels` | array | `[]` |  | Optional. List of labels associated with this route table. |
| `name` | string |  |  | Required. The route table name. |
| `routes` | array | `[]` |  | Optional. List of all routes. |
| `virtualHubName` | string |  |  | Required. The virtual hub name. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed virtual hub route table |
| `resourceGroupName` | string | The resource group the virtual hub route table was deployed into |
| `resourceId` | string | The resource ID of the deployed virtual hub route table |

## Template references

- [Virtualhubs/Hubroutetables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualHubs/hubRouteTables)

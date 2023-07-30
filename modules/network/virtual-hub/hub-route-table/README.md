# Virtual Hub Route Tables `[Microsoft.Network/virtualHubs/hubRouteTables]`

This module deploys a Virtual Hub Route Table.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualHubs/hubRouteTables` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualHubs/hubRouteTables) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The route table name. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `virtualHubName` | string | The name of the parent virtual hub. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `labels` | array | `[]` | List of labels associated with this route table. |
| `routes` | array | `[]` | List of all routes. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed virtual hub route table. |
| `resourceGroupName` | string | The resource group the virtual hub route table was deployed into. |
| `resourceId` | string | The resource ID of the deployed virtual hub route table. |

## Cross-referenced modules

_None_

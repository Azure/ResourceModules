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
| `Microsoft.Network/virtualHubs/hubRouteTables` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/virtualHubs/hubRouteTables) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The route table name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualHubName`](#parameter-virtualhubname) | string | The name of the parent virtual hub. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`labels`](#parameter-labels) | array | List of labels associated with this route table. |
| [`routes`](#parameter-routes) | array | List of all routes. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `labels`

List of labels associated with this route table.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `name`

The route table name.
- Required: Yes
- Type: string

### Parameter: `routes`

List of all routes.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualHubName`

The name of the parent virtual hub. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed virtual hub route table. |
| `resourceGroupName` | string | The resource group the virtual hub route table was deployed into. |
| `resourceId` | string | The resource ID of the deployed virtual hub route table. |

## Cross-referenced modules

_None_

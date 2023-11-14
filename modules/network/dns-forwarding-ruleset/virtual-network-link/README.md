# Dns Forwarding Rulesets Virtual Network Links `[Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks]`

This template deploys Virtual Network Link in a Dns Forwarding Ruleset.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets/virtualNetworkLinks) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | Link to another virtual network resource ID. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dnsForwardingRulesetName`](#parameter-dnsforwardingrulesetname) | string | The name of the parent DNS Fowarding Rule Set. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | The location of the PrivateDNSZone. Should be global. |
| [`name`](#parameter-name) | string | The name of the virtual network link. |

### Parameter: `dnsForwardingRulesetName`

The name of the parent DNS Fowarding Rule Set. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location of the PrivateDNSZone. Should be global.
- Required: No
- Type: string
- Default: `'global'`

### Parameter: `name`

The name of the virtual network link.
- Required: No
- Type: string
- Default: `[format('{0}-vnetlink', last(split(parameters('virtualNetworkResourceId'), '/')))]`

### Parameter: `virtualNetworkResourceId`

Link to another virtual network resource ID.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed virtual network link. |
| `resourceGroupName` | string | The resource group of the deployed virtual network link. |
| `resourceId` | string | The resource ID of the deployed virtual network link. |

## Cross-referenced modules

_None_

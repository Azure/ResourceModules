# EventHub Namespaces NetworkRuleSets `[Microsoft.EventHub/namespaces/networkRuleSets]`

This module deploys EventHub Namespaces NetworkRuleSets.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventHub/namespaces/networkRuleSets` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-11-01/namespaces/networkRuleSets) |

## Parameters

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `namespaceName` | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `defaultAction` | string | `'Allow'` | `[Allow, Deny]` | Default Action for Network Rule Set. Default is "Allow". It will not be set if publicNetworkAccess is "Disabled". Otherwise, it will be set to "Deny" if ipRules or virtualNetworkRules are being used. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `ipRules` | array | `[]` |  | List of IpRules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny". |
| `publicNetworkAccess` | string | `'Enabled'` | `[Disabled, Enabled]` | This determines if traffic is allowed over public network. Default is "Enabled". If set to "Disabled", traffic to this namespace will be restricted over Private Endpoints only and network rules will not be applied. |
| `trustedServiceAccessEnabled` | bool | `True` |  | Value that indicates whether Trusted Service Access is enabled or not. Default is "true". It will not be set if publicNetworkAccess is "Disabled". |
| `virtualNetworkRules` | array | `[]` |  | List virtual network rules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny". |


### Parameter Usage: `<virtualNetworkRules>`

Contains an array of subnets that this Event Hub Namespace is exposed to via Service Endpoints. You can enable the `ignoreMissingVnetServiceEndpoint` if you wish to add this virtual network to Event Hub Namespace but do not have an existing service endpoint.

```json
"virtualNetworkRules": {
    "value": [
      {
        "ignoreMissingVnetServiceEndpoint": true,
        "subnet": {
          "id": "/subscriptions/<<subscriptionId>>/resourcegroups/<<resourceGroupName>>/providers/Microsoft.Network/virtualNetworks/<<virtualNetworkName>>/subnets/<<subnetName1>>"
        }
      },
      {
      "ignoreMissingVnetServiceEndpoint": false,
      "subnet": {
        "id": "/subscriptions/<<subscriptionId>>/resourcegroups/<<resourceGroupName>>/providers/Microsoft.Network/virtualNetworks/<<virtualNetworkName>>/subnets/<<subnetName2>>"
        }
      }
    ]
}
```

### Parameter Usage: `<ipRules>`

Contains an array of objects for the public IP ranges you want to allow via the Event Hub Namespace firewall. Supports IPv4 address or CIDR.

```json
"ipRules": {
    "value": [
      {
        "action": "Allow",
        "ipMask": "a.b.c.d/e"
      },
      {
        "action": "Allow",
        "ipMask": "x.x.x.x/x"
      }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the network rule set. |
| `resourceGroupName` | string | The name of the resource group the network rule set was created in. |
| `resourceId` | string | The resource ID of the network rule set. |

## Cross-referenced modules

_None_

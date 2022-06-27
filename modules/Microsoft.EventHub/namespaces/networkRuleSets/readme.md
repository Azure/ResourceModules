# EventHub Namespaces NetworkRuleSets `[Microsoft.EventHub/namespaces/networkRuleSets]`

This module deploys EventHub Namespaces NetworkRuleSets.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventHub/namespaces/networkRuleSets` | [2021-11-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-11-01/namespaces/networkRuleSets) |

## Parameters

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `namespaceName` | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `defaultAction` | string | `'Allow'` | `[Allow, Deny]` | Default Action for Network Rule Set. Default is "Allow". Will be set to "Deny" if ipRules/virtualNetworkRules or are being used. If ipRules/virtualNetworkRules are not used and PublicNetworkAccess is set to "Disabled", setting this to "Deny" would render the namespace resources inaccessible for data-plane requests. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `ipRules` | array | `[]` |  | List of IpRules. When used, defaultAction will be set to "Deny" and publicNetworkAccess will be set to "Enabled". |
| `publicNetworkAccess` | string | `'Enabled'` | `[Enabled, Disabled]` | This determines if traffic is allowed over public network. Default it is "Enabled". If set to "Disabled", traffic to this namespace will be restricted over Private Endpoints only. |
| `trustedServiceAccessEnabled` | bool | `True` | `[True, False]` | Value that indicates whether Trusted Service Access is Enabled or not. Default is "true". |
| `virtualNetworkRules` | array | `[]` |  | List VirtualNetwork Rules. When used, defaultAction will be set to "Deny" and publicNetworkAccess will be set to "Enabled". |


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

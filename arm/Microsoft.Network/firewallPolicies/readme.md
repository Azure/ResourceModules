# Network Firewall Policies `[Microsoft.Network/firewallPolicies]`

This module deploys Network Firewall Policies.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/firewallPolicies` | 2021-05-01 |
| `Microsoft.Network/firewallPolicies/ruleCollectionGroups` | 2021-05-01 |
| `Microsoft.Network/firewallPolicies/ruleGroups` | 2020-04-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `basePolicyResourceId` | string |  |  | Optional. Resource ID of the base policy. |
| `bypassTrafficSettings` | array | `[]` |  | Optional. List of rules for traffic to bypass. |
| `certificateName` | string |  |  | Optional. Name of the CA certificate. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `defaultWorkspaceId` | string |  |  | Optional. Default Log Analytics Resource ID for Firewall Policy Insights. |
| `enableProxy` | bool | `False` |  | Optional. Enable DNS Proxy on Firewalls attached to the Firewall Policy. |
| `fqdns` | array | `[]` |  | Optional. List of FQDNs for the ThreatIntel Allowlist. |
| `insightsIsEnabled` | bool | `False` |  | Optional. A flag to indicate if the insights are enabled on the policy. |
| `ipAddresses` | array | `[]` |  | Optional. List of IP addresses for the ThreatIntel Allowlist. |
| `keyVaultSecretId` | string |  |  | Optional. Secret Id of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in KeyVault.	 |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `mode` | string | `Off` | `[Alert, Deny, Off]` | Optional. The configuring of intrusion detection. |
| `name` | string |  |  | Required. Name of the Firewall Policy. |
| `privateRanges` | array | `[]` |  | Optional. List of private IP addresses/IP address ranges to not be SNAT. |
| `retentionDays` | int | `365` |  | Optional. Number of days the insights should be enabled on the policy. |
| `ruleCollectionGroups` | _[ruleCollectionGroups](ruleCollectionGroups/readme.md)_ array | `[]` |  | Optional. Rule collection groups. |
| `ruleGroups` | _[ruleGroups](ruleGroups/readme.md)_ array | `[]` |  | Optional. Rule groups. |
| `servers` | array | `[]` |  | Optional. List of Custom DNS Servers. |
| `signatureOverrides` | array | `[]` |  | Optional. List of specific signatures states. |
| `systemAssignedIdentity` | bool | `False` |  | Optional. Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Optional. Tags of the Firewall policy resource. |
| `threatIntelMode` | string | `Off` | `[Alert, Deny, Off]` | Optional. The operation mode for Threat Intel. |
| `tier` | string | `Standard` | `[Premium, Standard]` | Optional. Tier of Firewall Policy. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `workspaces` | array | `[]` |  | Optional. List of workspaces for Firewall Policy Insights. |

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
},
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed firewall policy |
| `resourceGroupName` | string | The resource group of the deployed firewall policy |
| `resourceId` | string | The resource ID of the deployed firewall policy |

## Template references

- ['firewallPolicies/ruleGroups' Parent Documentation](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/firewallPolicies)
- [Firewallpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/firewallPolicies)
- [Firewallpolicies/Rulecollectiongroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/firewallPolicies/ruleCollectionGroups)

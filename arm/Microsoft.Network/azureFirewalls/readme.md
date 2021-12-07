# Azure Firewalls `[Microsoft.Network/azureFirewalls]`

This module deploys a firewall.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/azureFirewalls` | 2021-02-01 |
| `Microsoft.Network/publicIPAddresses` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `applicationRuleCollections` | array | `[]` |  | Optional. Collection of application rule collections used by Azure Firewall. |
| `availabilityZones` | array | `[1, 2, 3]` |  | Optional. Zone numbers e.g. 1,2,3. |
| `azureFirewallPipName` | string |  |  | Optional. Specifies the name of the Public IP used by Azure Firewall. If it's not provided, a '-pip' suffix will be appended to the Firewall's name. |
| `azureSkuName` | string | `AZFW_VNet` | `[AZFW_VNet, AZFW_Hub]` | Optional. Name of an Azure Firewall SKU. |
| `azureSkuTier` | string | `Standard` | `[Standard, Premium]` | Optional. Tier of an Azure Firewall. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Diagnostic Storage Account resource identifier |
| `enableDnsProxy` | bool |  |  | Optional. Enable the preview feature for DNS proxy. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `firewallLogsToEnable` | array | `[AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy]` | `[AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy]` | Optional. The name of firewall logs that will be streamed. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. Name of the Azure Firewall. |
| `natRuleCollections` | array | `[]` |  | Optional. Collection of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | `[]` |  | Optional. Collection of network rule collections used by Azure Firewall. |
| `publicIPLogsToEnable` | array | `[DDoSProtectionNotifications, DDoSMitigationReports, DDoSMitigationFlowLogs]` | `[DDoSProtectionNotifications, DDoSMitigationReports, DDoSMitigationFlowLogs]` | Optional. The name of public IP logs that will be streamed. |
| `publicIPPrefixId` | string |  |  | Optional. Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Tags of the Automation Account resource. |
| `vNetId` | string |  |  | Required. Shared services Virtual Network resource ID |
| `workspaceId` | string |  |  | Optional. Log Analytics workspace resource identifier |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `applicationRuleCollections` | array | List of Application Rule Collections |
| `azureFirewallName` | string | The name of the Azure firewall |
| `azureFirewallPrivateIp` | string | The private IP of the Azure Firewall |
| `azureFirewallPublicIp` | string | The public IP of the Azure Firewall |
| `azureFirewallResourceGroup` | string | The resource group the azure firewall was deployed into |
| `azureFirewallResourceId` | string | The resource ID of the Azure firewall |
| `natRuleCollections` | array | Collection of NAT rule collections used by Azure Firewall |
| `networkRuleCollections` | array | List of Network Rule Collections |

## Considerations

The `applicationRuleCollections` parameter accepts a JSON Array of AzureFirewallApplicationRule objects.
The `networkRuleCollections` parameter accepts a JSON Array of AzureFirewallNetworkRuleCollection objects.

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Azurefirewalls](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/azureFirewalls)
- [Publicipaddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/publicIPAddresses)

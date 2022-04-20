# Azure Firewalls `[Microsoft.Network/azureFirewalls]`

This module deploys a firewall.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Considerations](#Considerations)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/azureFirewalls` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `ipConfigurations` | array | List of IP Configurations. |
| `name` | string | Name of the Azure Firewall. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `applicationRuleCollections` | array | `[]` |  | Collection of application rule collections used by Azure Firewall. |
| `azureSkuName` | string | `'AZFW_VNet'` | `[AZFW_VNet, AZFW_Hub]` | Name of an Azure Firewall SKU. |
| `azureSkuTier` | string | `'Standard'` | `[Standard, Premium]` | Tier of an Azure Firewall. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy]` | `[AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy]` | The name of firewall logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Diagnostic Storage Account resource identifier |
| `diagnosticWorkspaceId` | string | `''` |  | Log Analytics workspace resource identifier |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `firewallPolicyId` | string | `''` |  | Resource ID of the Firewall Policy that should be attached. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `natRuleCollections` | array | `[]` |  | Collection of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | `[]` |  | Collection of network rule collections used by Azure Firewall. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Tags of the Azure Firewall resource. |
| `threatIntelMode` | string | `'Deny'` | `[Alert, Deny, Off]` | The operation mode for Threat Intel. |
| `zones` | array | `[1, 2, 3]` |  | Zone numbers e.g. 1,2,3. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
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
| `name` | string | The name of the Azure firewall |
| `natRuleCollections` | array | Collection of NAT rule collections used by Azure Firewall |
| `networkRuleCollections` | array | List of Network Rule Collections |
| `privateIp` | string | The private IP of the Azure firewall |
| `resourceGroupName` | string | The resource group the Azure firewall was deployed into |
| `resourceId` | string | The resource ID of the Azure firewall |

## Considerations

The `applicationRuleCollections` parameter accepts a JSON Array of AzureFirewallApplicationRule objects.
The `networkRuleCollections` parameter accepts a JSON Array of AzureFirewallNetworkRuleCollection objects.

## Template references

- [Azurefirewalls](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/azureFirewalls)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

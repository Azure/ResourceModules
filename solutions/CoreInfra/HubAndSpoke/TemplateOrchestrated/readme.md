# `[Microsoft.]`

This module deploys .
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Automanage/configurationProfileAssignments` | [2021-04-30-preview](https://docs.microsoft.com/en-us/azure/templates) |
| `Microsoft.Compute/virtualMachines` | [2021-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-07-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2021-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-07-01/virtualMachines/extensions) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/azureFirewalls` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/azureFirewalls) |
| `Microsoft.Network/bastionHosts` | [2022-01-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-01-01/bastionHosts) |
| `Microsoft.Network/networkInterfaces` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkInterfaces) |
| `Microsoft.Network/networkSecurityGroups` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkSecurityGroups) |
| `Microsoft.Network/networkSecurityGroups/securityRules` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/networkSecurityGroups/securityRules) |
| `Microsoft.Network/publicIPAddresses` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/publicIPAddresses) |
| `Microsoft.Network/routeTables` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/routeTables) |
| `Microsoft.Network/virtualNetworks` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2022-02-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-02-01/vaults/backupFabrics/protectionContainers/protectedItems) |
| `Microsoft.Resources/resourceGroups` | [2019-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-05-01/resourceGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | Name of the Resource Group. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `azureFirewallName` | string |  |  | Azure Firewall Name |
| `bastion_nsg_rules` | array | `[]` |  | NSG security rules for the Azure Bastion Host subnet. |
| `bastionName` | string | `''` |  | Name of the Azure Bastion Service. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the storage account to be used for diagnostic logs. |
| `eventHubAuthorizationRuleId` | string | `''` |  | Authorization ID of the Event Hub Namespace to be used for diagnostic logs. |
| `eventHubName` | string | `''` |  | Name of the Event Hub to be used for diagnostic logs. |
| `location` | string | `[deployment().location]` |  | Resource Group location |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock for all resources/resource group defined in this template. |
| `nsgBastionSubnetName` | string | `''` |  | Name of the network security group for the Azure Bastion Host subnet. |
| `tags` | object | `{object}` |  | Tags to be applied on all resources/resource groups in this deployment. |
| `vnet_hub` | string | `'vnet-hub'` |  | Name of the hub virtual network. |
| `vnetName2` | string | `'vnet-spoke'` |  | Name of the spoke virtual network. |
| `workspaceId` | string | `''` |  | Resource ID of the Log Analytics workspace to be used for diagnostic logs. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type |
| :-- | :-- |

## Cross-referenced modules

_None_

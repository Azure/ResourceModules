# AzureFirewall

This module deploys Azure Firewall.

## Resource types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Network/publicIPAddresses`|2020-08-01|
|`Microsoft.Network/publicIPAddresses/providers/diagnosticSettings`|2017-05-01-preview|
|`Microsoft.Network/azureFirewalls`|2020-08-01|
|`Microsoft.Resources/deployments`|2019-10-01|
|`Microsoft.Network/azureFirewalls/providers/diagnosticsettings`|2016-09-01|
|`Microsoft.Network/azureFirewalls/providers/roleAssignments`|2018-09-01-preview|
| `providers/locks` | 2016-09-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
|---|---|---|---|---|
| `azureFirewallName` | string |  |  | Required. Name of the Azure Firewall. |
| `azureSkuName` | string | `AZFW_VNet` | `AZFW_VNet`, `AZFW_Hub` | Optional. Name of an Azure Firewall SKU. |
| `azureSkuTier` | string | `Standard` | `Standard`, `Premium` | Optional. Tier of an Azure Firewall. |
| `enableDnsProxy` | bool | `true` |  | Optional. Enable the preview feature for DNS proxy. |
| `applicationRuleCollections` | array | [] |  | Optional. Collection of application rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | [] |  | Optional. Collection of network rule collections used by Azure Firewall. |
| `natRuleCollections` | array | [] |  | Optional. Collection of NAT rule collections used by Azure Firewall. |
| `vNetId` | string |  |  | Required. Shared services Virtual Network resource Id |
| `azureFirewallPipName` | string |  |  | Optional. Specifies the name of the Public IP used by Azure Firewall. If it's not provided, a '-pip' suffix will be appended to the Firewall's name. |
| `publicIPPrefixId` | string |  |  | Optional. Resource Id of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| `diagnosticStorageAccountId` | string |  |  | Required. Diagnostic Storage Account resource identifier |
| `workspaceId` | string |  |  | Required. Log Analytics workspace resource identifier |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `roleAssignments` | array | [] | Complex structure, see below. | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `lockForDeletion` | bool | false |  | Optional. Switch to lock the Firewall from deletion. |
| `tags` | object | {} | Complex structure, see below. | Optional. Tags of the Azure Key Vault resource. |
| `cuaId` | string | "" |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `location` | string | resourceGroup().location |  | Optional. Location for all resources. |
| `availabilityZones` | array | ["1","2","3"] |  | Optional. Availability Zones for deployment. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
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
| `applicationRuleCollections` | array | List of Application Rule Collections. |
| `azureFirewallName` | string | The Name of the Azure Firewall. |
| `azureFirewallPrivateIp` | string | The private IP of the Azure Firewall. |
| `azureFirewallPublicIp` | string | The public IP of the Azure Firewall. |
| `azureFirewallResourceGroup` | string | The name of the Resource Group the Azure Firewall was created in. |
| `azureFirewallResourceId` | string | The Resource Id of the Azure Firewall. |
| `natRuleCollections` | array | Optional. Collection of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | List of Network Rule Collections. |

## Considerations

The `applicationRuleCollections` parameter accepts a JSON Array of AzureFirewallApplicationRule objects.

The `networkRuleCollections` parameter accepts a JSON Array of AzureFirewallNetworkRuleCollection objects.

## Additional resources

- [Microsoft.Network azureFirewalls template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2020-05-01/azurefirewalls)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)

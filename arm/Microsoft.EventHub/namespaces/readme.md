# EventHub Namespaces

This module deploys EventHub Namespace.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.EventHub/namespaces`|2017-04-01|
|`Microsoft.EventHub/namespaces/disasterRecoveryConfigs`|2017-04-01|
|`Microsoft.EventHub/namespaces/AuthorizationRules`|2017-04-01|
|`providers/locks`|2016-09-01|
|`Microsoft.EventHub/namespaces/providers/diagnosticsettings`|2017-05-01-preview|
|`Microsoft.EventHub/namespaces/providers/roleAssignments`|2018-09-01-preview|
|`Microsoft.Network/privateEndpoints`|2020-05-01|
|`Microsoft.Network/privateEndpoints/privateDnsZoneGroups`|2020-05-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | array | Optional. Authorization Rules for the Event Hub namespace | System.Object[] |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `isAutoInflateEnabled` | bool | Optional. Switch to enable the Auto Inflate feature of Event Hub. | False |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Key Vault from deletion. | False |  |
| `maximumThroughputUnits` | int | Optional. Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units. | 1 |  |
| `namespaceAlias` | string | Optional. The Disaster Recovery configuration name |  |  |
| `namespaceName` | string | Optional. The name of the EventHub namespace. If no name is provided, then unique name will be created.|  |  |
| `networkAcls` | object | Optional. Service endpoint object information |  |  |
| `privateEndpoints` | array | System.Object[] |  | Optional. Configuration Details for private endpoints. |
| `partnerNamespaceId` | string | Optional. ARM Id of the Primary/Secondary eventhub namespace name, which is part of GEO DR pairing |  |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `skuCapacity` | int | Optional. Event Hub Plan scale-out capacity of the resource | 1 |  |
| `skuName` | string | Optional. EventHub Plan sku name | Standard | System.Object[] |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `vNetId` | string | Optional. Virtual Network Id to lock down the Event Hub. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |
| `zoneRedundant` | bool | Optional. Switch to make the Event Hub Namespace zone redundant. | False |  |
| `baseTime` | string | utcNow('u') | | Generated. Do not provide a value! This date value is used to generate a SAS token toaccess the modules.

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

### Parameter Usage: `authorizationRules`

Default value:

```json
"authorizationRules": {
    "value": [
        {
            "name": "RootManageSharedAccessKey",
            "properties": {
                "rights": [
                    "Listen",
                    "Manage",
                    "Send"
                ]
            }
        }
    ]
}
```

### Parameter Usage: `networkAcls`

```json
"networkAcls": {
    "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "virtualNetworkRules": [
            {
                "subnet": "sharedsvcs"
            }
        ],
        "ipRules": []
    }
}
```

### Parameter Usage: `vNetId`

```json
"vNetId": {
    "value": "/subscriptions/00000000/resourceGroups/resourceGroup"
}
```

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.

- Although not strictly required, it is highly recommened to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-sa-cac-y-123-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "blob",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
            ],
            "customDnsConfigs": [ // Optional
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "file"
        }
    ]
}
```
## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `defaultAuthorizationRuleId` | string | The Id of the authorization rule marked by the variable with the same name. |
| `namespaceConnectionString` | securestring | The connection string of the EventHub Namespace |
| `namespaceName` | string | The Name of the EventHub Namespace |
| `namespaceResourceGroup` | string | The name of the Resource Group with the EventHub Namespace |
| `namespaceResourceId` | string | The Resource Id of the EventHub Namespace |
| `sharedAccessPolicyPrimaryKey` | securestring | The shared access policy primary key for the EventHub Namespace |

### Scripts

- There is no Scripts for this Module

## Considerations

- There is no deployment considerations for this Module

## Additional resources

- [Microsoft EventHub template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.eventhub/allversions)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)

# ServiceBusNamespaces `[Microsoft.ServiceBus/namespaces]`

This module deploys Service Bus Namespace resource.

## Resource types
| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Network/privateEndpoints` | 2021-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |
| `Microsoft.ServiceBus/namespaces` | 2018-01-01-preview |
| `Microsoft.ServiceBus/namespaces/AuthorizationRules` | 2017-04-01 |
| `Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs` | 2017-04-01 |
| `Microsoft.ServiceBus/namespaces/ipfilterrules` | 2018-01-01-preview |
| `Microsoft.ServiceBus/namespaces/migrationConfigurations` | 2017-04-01 |
| `Microsoft.ServiceBus/namespaces/providers/roleAssignments` | 2020-04-01-preview |
| `Microsoft.ServiceBus/namespaces/virtualnetworkrules` | 2018-01-01-preview |

## Parameters
| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | array | `[System.Collections.Hashtable]` |  | Optional. Authorization Rules for the Service Bus namespace |
| `baseTime` | string | `[utcNow('u')]` |  | Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `ipFilterRules` | array | `[]` |  | Optional. IP Filter Rules for the Service Bus namespace |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lockForDeletion` | bool |  |  | Optional. Flag indicating if resource is locked for deletion. |
| `logsToEnable` | array | `[OperationalLogs]` | `[OperationalLogs]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `namespaceAlias` | string |  |  | Optional. The Disaster Recovery configuration name |
| `partnerNamespaceId` | string |  |  | Optional. ARM Id of the Primary/Secondary Service Bus namespace name, which is part of GEO DR pairing |
| `postMigrationName` | string |  |  | Optional. Name to access Standard Namespace after migration. |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration Details for private endpoints. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `serviceBusNamespaceName` | string |  |  | Optional. Name of the Service Bus Namespace. If no name is provided, then unique name will be created. |
| `skuName` | string | `Basic` | `[Basic, Standard, Premium]` | Required. Name of this SKU. - Basic, Standard, Premium |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `targetNamespace` | string |  |  | Optional. Existing premium Namespace ARM Id name which has no entities, will be used for migration. |
| `virtualNetworkRuleSubnetIds` | array | `[]` |  | Optional. vNet Rules SubnetIds for the Service Bus namespace. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |
| `zoneRedundant` | bool |  |  | Optional. Enabling this property creates a Premium Service Bus Namespace in regions supported availability zones. |

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

### Parameter Usage: `ipFilterRules`

```json
"ipFilterRules": {
    "value": [
        {
            "filterName": "ipFilter1",
            "ipMask": "10.0.1.0/32",
            "action": "Accept"
        },
        {
            "filterName": "ipFilter2",
            "ipMask": "10.0.2.0/32",
            "action": "Deny"
        }
    ]
}
```

### Parameter Usage: `virtualNetworkRuleSubnetIds`

```json
"virtualNetworkRuleSubnetIds": {
    "value": [
        "/subscriptions/<subscription-id>/resourceGroups/resourceGroup/providers/Microsoft.Network/virtualNetworks/<vnet-name>/subnets/<subnet-name>",
        "/subscriptions/<subscription-id>/resourceGroups/resourceGroup/providers/Microsoft.Network/virtualNetworks/<vnet-name>/subnets/<subnet-name>"
    ]
}
```

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
            "service": "vault",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
            ],
            "customDnsConfigs": [ // Optional
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
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
| Output Name | Type |
| :-- | :-- |
| `defaultAuthorizationRuleId` | string |
| `serviceBusConnectionString` | string |
| `serviceBusNamespaceName` | string |
| `serviceBusNamespaceResourceGroup` | string |
| `serviceBusNamespaceResourceId` | string |

## Template references
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/privateEndpoints/privateDnsZoneGroups)
- [Namespaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces)
- [Namespaces/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/AuthorizationRules)
- [Namespaces/Disasterrecoveryconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/disasterRecoveryConfigs)
- [Namespaces/Ipfilterrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces/ipfilterrules)
- [Namespaces/Migrationconfigurations](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/migrationConfigurations)
- [Namespaces/Virtualnetworkrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces/virtualnetworkrules)

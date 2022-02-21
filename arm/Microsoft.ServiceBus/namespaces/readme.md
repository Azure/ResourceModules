# Service Bus Namespaces `[Microsoft.ServiceBus/namespaces]`

This module deploys a service bus namespace resource.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/privateEndpoints` | 2021-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-05-01 |
| `Microsoft.ServiceBus/namespaces` | 2021-06-01-preview |
| `Microsoft.ServiceBus/namespaces/AuthorizationRules` | 2017-04-01 |
| `Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs` | 2017-04-01 |
| `Microsoft.ServiceBus/namespaces/ipfilterrules` | 2018-01-01-preview |
| `Microsoft.ServiceBus/namespaces/migrationConfigurations` | 2017-04-01 |
| `Microsoft.ServiceBus/namespaces/queues` | 2021-06-01-preview |
| `Microsoft.ServiceBus/namespaces/queues/authorizationRules` | 2017-04-01 |
| `Microsoft.ServiceBus/namespaces/topics` | 2021-06-01-preview |
| `Microsoft.ServiceBus/namespaces/topics/authorizationRules` | 2021-06-01-preview |
| `Microsoft.ServiceBus/namespaces/virtualnetworkrules` | 2018-01-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | _[authorizationRules](authorizationRules/readme.md)_ array | `[System.Collections.Hashtable]` |  | Optional. Authorization Rules for the Service Bus namespace |
| `baseTime` | string | `[utcNow('u')]` |  | Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. |
| `disasterRecoveryConfigs` | _[disasterRecoveryConfigs](disasterRecoveryConfigs/readme.md)_ object | `{object}` |  | Optional. The disaster recovery configuration. |
| `ipFilterRules` | _[ipFilterRules](ipFilterRules/readme.md)_ array | `[]` |  | Optional. IP Filter Rules for the Service Bus namespace |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[OperationalLogs]` | `[OperationalLogs]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `migrationConfigurations` | _[migrationConfigurations](migrationConfigurations/readme.md)_ object | `{object}` |  | Optional. The migration configuration. |
| `name` | string |  |  | Optional. Name of the Service Bus Namespace. If no name is provided, then unique name will be created. |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration Details for private endpoints. |
| `queues` | _[queues](queues/readme.md)_ array | `[]` |  | Optional. The queues to create in the service bus namespace |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `skuName` | string | `Basic` | `[Basic, Standard, Premium]` | Required. Name of this SKU. - Basic, Standard, Premium |
| `systemAssignedIdentity` | bool |  |  | Optional. Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `topics` | _[topics](topics/readme.md)_ array | `[]` |  | Optional. The topics to create in the service bus namespace |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `virtualNetworkRules` | _[virtualNetworkRules](virtualNetworkRules/readme.md)_ array | `[]` |  | Optional. vNet Rules SubnetIds for the Service Bus namespace. |
| `zoneRedundant` | bool |  |  | Optional. Enabling this property creates a Premium Service Bus Namespace in regions supported availability zones. |

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

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "blob",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
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
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "file"
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
| `name` | string | The name of the deployed service bus namespace |
| `resourceGroupName` | string | The resource group of the deployed service bus namespace |
| `resourceId` | string | The resource ID of the deployed service bus namespace |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Namespaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces)
- [Namespaces/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/AuthorizationRules)
- [Namespaces/Disasterrecoveryconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/disasterRecoveryConfigs)
- [Namespaces/Ipfilterrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces/ipfilterrules)
- [Namespaces/Migrationconfigurations](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/migrationConfigurations)
- [Namespaces/Queues](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces/queues)
- [Namespaces/Queues/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/queues/authorizationRules)
- [Namespaces/Topics](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces/topics)
- [Namespaces/Topics/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-06-01-preview/namespaces/topics/authorizationRules)
- [Namespaces/Virtualnetworkrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2018-01-01-preview/namespaces/virtualnetworkrules)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

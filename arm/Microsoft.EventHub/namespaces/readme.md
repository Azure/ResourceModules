# Event Hub Namespaces `[Microsoft.EventHub/namespaces]`

This module deploys an event hub namespace.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.EventHub/namespaces` | 2021-06-01-preview |
| `Microsoft.EventHub/namespaces/authorizationRules` | 2017-04-01 |
| `Microsoft.EventHub/namespaces/disasterRecoveryConfigs` | 2017-04-01 |
| `Microsoft.EventHub/namespaces/eventhubs` | 2021-06-01-preview |
| `Microsoft.EventHub/namespaces/eventhubs/authorizationRules` | 2021-06-01-preview |
| `Microsoft.EventHub/namespaces/eventhubs/consumergroups` | 2021-06-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/privateEndpoints` | 2021-05-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authorizationRules` | _[authorizationRules](authorizationRules/readme.md)_ array | `[System.Collections.Hashtable]` |  | Optional. Authorization Rules for the Event Hub namespace |
| `baseTime` | string | `[utcNow('u')]` |  | Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. |
| `disasterRecoveryConfig` | object | `{object}` |  | Optional. The disaster recovery config for this namespace |
| `eventHubs` | _[eventHubs](eventHubs/readme.md)_ array | `[]` |  | Optional. The event hubs to deploy into this namespace |
| `isAutoInflateEnabled` | bool |  |  | Optional. Switch to enable the Auto Inflate feature of Event Hub. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[ArchiveLogs, OperationalLogs, KafkaCoordinatorLogs, KafkaUserErrorLogs, EventHubVNetConnectionEvent, CustomerManagedKeyUserLogs, AutoScaleLogs]` | `[ArchiveLogs, OperationalLogs, KafkaCoordinatorLogs, KafkaUserErrorLogs, EventHubVNetConnectionEvent, CustomerManagedKeyUserLogs, AutoScaleLogs]` | Optional. The name of logs that will be streamed. |
| `maximumThroughputUnits` | int | `1` |  | Optional. Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Optional. The name of the event hub namespace. If no name is provided, then unique name will be created. |
| `networkAcls` | object | `{object}` |  | Optional. Service endpoint object information |
| `privateEndpoints` | array | `[]` |  | Optional. Configuration Details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.|
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `skuCapacity` | int | `1` |  | Optional. Event Hub plan scale-out capacity of the resource |
| `skuName` | string | `Standard` | `[Basic, Standard]` | Optional. event hub plan SKU name |
| `systemAssignedIdentity` | bool |  |  | Optional. Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `vNetId` | string |  |  | Optional. Virtual Network ID to lock down the Event Hub. |
| `zoneRedundant` | bool |  |  | Optional. Switch to make the Event Hub Namespace zone redundant. |

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
| `name` | string | The name of the eventspace. |
| `resourceGroupName` | string | The resource group where the namespace is deployed. |
| `resourceId` | string | The resource ID of the eventspace. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Namespaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces)
- [Namespaces/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2017-04-01/namespaces/authorizationRules)
- [Namespaces/Disasterrecoveryconfigs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2017-04-01/namespaces/disasterRecoveryConfigs)
- [Namespaces/Eventhubs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs)
- [Namespaces/Eventhubs/Authorizationrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs/authorizationRules)
- [Namespaces/Eventhubs/Consumergroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2021-06-01-preview/namespaces/eventhubs/consumergroups)
- [Privateendpoints](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/privateEndpoints)
- [Privateendpoints/Privatednszonegroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/privateEndpoints/privateDnsZoneGroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

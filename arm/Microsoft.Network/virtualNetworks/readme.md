# Virtual Networks `[Microsoft.Network/virtualNetworks]`

This template deploys a virtual network (vNet).

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/virtualNetworks` | 2021-05-01 |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `addressPrefixes` | array |  |  | Required. An Array of 1 or more IP Address Prefixes for the Virtual Network. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `ddosProtectionPlanId` | string |  |  | Optional. Resource ID of the DDoS protection plan to assign the VNET to. If it's left blank, DDoS protection will not be configured. If it's provided, the VNET created by this template will be attached to the referenced DDoS protection plan. The DDoS protection plan can exist in the same or in a different subscription. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `dnsServers` | array | `[]` |  | Optional. DNS Servers associated to the Virtual Network. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[VMProtectionAlerts]` | `[VMProtectionAlerts]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. The Virtual Network (vNet) Name. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `subnets` | array |  |  | Required. An Array of subnets to deploy to the Virual Network. |
| `nsgResourceGroup` | string | `[resourceGroup().name]` |  | Optional. Resource Group where NSGs are deployed, if different than VNET Resource Group. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `virtualNetworkPeerings` | _[virtualNetworkPeerings](virtualNetworkPeerings/readme.md)_ array | `[]` |  | Optional. Virtual Network Peerings configurations |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics. |

### Parameter Usage: `addressPrefixes`

The `addressPrefixes` parameter accepts a JSON Array of string values containing the IP Address Prefixes for the Virtual Network (vNet).

Here's an example of specifying a single Address Prefix:

```json
"addressPrefixes": {
    "value": [
        "10.1.0.0/16"
    ]
}
```

### Parameter Usage: `subnets`

The `subnets` parameter accepts a JSON Array of `subnet` objects to deploy to the Virtual Network.

Here's an example of specifying a couple Subnets to deploy:

```json
"subnets": {
    "value": [
    {
        "name": "GatewaySubnet",
        "addressPrefix": "10.0.255.0/24",
        "networkSecurityGroupName": "nsgName1",
        "routeTableName": "UdrName1",
        "delegations": [],
        "natGateway": "", // Name of the NAT Gateway to use for the subnet.
        "serviceEndpoints": [
            {
                "service": "Microsoft.EventHub"
            },
            {
                "service": "Microsoft.Sql"
            },
            {
                "service": "Microsoft.Storage"
            },
            {
                "service": "Microsoft.KeyVault"
            }
        ]
    },
    {
        "name": "examplePrivateEndpointSubnet",
        "addressPrefix": "10.0.200.0/24",
        "networkSecurityGroupName": "nsgName2",
        "routeTableName": "UdrName2",
        "delegations": [],
        "natGateway": "", // Name of the NAT Gateway to use for the subnet.
        "serviceEndpoints": [],
        "privateEndpointNetworkPolicies": "Disabled" // This property must be set to disabled for subnets that contain private endpoints. Default Value when not specified is "Enabled".
    },
    {
        "name": "data",
        "addressPrefix": "10.1.1.0/24"
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

## Considerations

When defining the Subnets to deploy using the `subnets` parameter, the JSON format to pass it must match the Subnet object that is normally passed in to the `subnets` property of a `virtualNetwork` within an ARM Template.

The network security group and route table resources must reside in the same resource group as the virtual network.

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `subnetNames` | array | The names of the deployed subnets |
| `subnetResourceIds` | array | The resource IDs of the deployed subnets |
| `virtualNetworkName` | string | The name of the virtual network |
| `virtualNetworkResourceGroup` | string | The resource group the virtual network was deployed into |
| `virtualNetworkResourceId` | string | The resource ID of the virtual network |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Virtualnetworks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualNetworks)
- [Virtualnetworks/Virtualnetworkpeerings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/virtualNetworks/virtualNetworkPeerings)

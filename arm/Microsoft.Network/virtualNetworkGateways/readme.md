# VirtualNetworkGateway `[Microsoft.Network/virtualNetworkGateways]`

This module deploys a Virtual Network Gateway.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Network/publicIPAddresses` | 2021-02-01 |
| `Microsoft.Network/virtualNetworkGateways` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `activeActive` | bool | `True` |  | Optional. Value to specify if the Gateway should be deployed in active-active or active-passive configuration |
| `asn` | int | `65815` |  | Optional. ASN value |
| `clientRevokedCertThumbprint` | string |  |  | Optional. Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet. |
| `clientRootCertData` | string |  |  | Optional. Client root certificate data used to authenticate VPN clients. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Required. Resource identifier of the Diagnostic Storage Account. |
| `domainNameLabel` | array | `[]` |  | Optional. DNS name(s) of the Public IP resource(s). If you enabled active-active configuration, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com |
| `enableBgp` | bool | `True` |  | Optional. Value to specify if BGP is enabled or not |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `gatewayPipName` | array | `[]` |  | Optional. Specifies the name of the Public IP used by the Virtual Network Gateway. If it's not provided, a '-pip' suffix will be appended to the gateway's name. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `publicIpLogsToEnable` | array | `[DDoSProtectionNotifications, DDoSMitigationFlowLogs, DDoSMitigationReports]` | `[DDoSProtectionNotifications, DDoSMitigationFlowLogs, DDoSMitigationReports]` | Optional. The name of logs that will be streamed. |
| `publicIPPrefixId` | string |  |  | Optional. Resource Id of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| `publicIpZones` | array | `[1]` |  | Optional. Specifies the zones of the Public IP address. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `virtualNetworkGatewayLogsToEnable` | array | `[GatewayDiagnosticLog, TunnelDiagnosticLog, RouteDiagnosticLog, IKEDiagnosticLog, P2SDiagnosticLog]` | `[GatewayDiagnosticLog, TunnelDiagnosticLog, RouteDiagnosticLog, IKEDiagnosticLog, P2SDiagnosticLog]` | Optional. The name of logs that will be streamed. |
| `virtualNetworkGatewayName` | string |  |  | Required. Specifies the Virtual Network Gateway name. |
| `virtualNetworkGatewaySku` | string |  | `[Basic, VpnGw1, VpnGw2, VpnGw3, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ]` | Required. The Sku of the Gateway. |
| `virtualNetworkGatewayType` | string |  | `[Vpn, ExpressRoute]` | Required. Specifies the gateway type. E.g. VPN, ExpressRoute |
| `vNetId` | string |  |  | Required. Virtual Network resource Id |
| `vpnClientAddressPoolPrefix` | string |  |  | Optional. The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network. |
| `vpnType` | string | `RouteBased` | `[PolicyBased, RouteBased]` | Required. Specifies the VPN type |
| `workspaceId` | string |  |  | Required. Resource identifier of Log Analytics. |

### Parameter Usage: `subnets`

The `subnets` parameter accepts a JSON Array of `subnet` objects to deploy to the Virtual Network.

Here's an example of specifying a couple Subnets to deploy:

```json
"subnets": {
    "value": [
    {
        "name": "app",
        "properties": {
        "addressPrefix": "10.1.0.0/24",
        "networkSecurityGroup": {
            "id": "[resourceId('Microsoft.Network/networkSecurityGroups', 'app-nsg')]"
        },
        "routeTable": {
            "id": "[resourceId('Microsoft.Network/routeTables', 'app-udr')]"
        }
        }
    },
    {
        "name": "data",
        "properties": {
        "addressPrefix": "10.1.1.0/24"
        }
    }
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
| `activeActive` | bool |
| `virtualNetworkGatewayName` | string |
| `virtualNetworkGatewayResourceGroup` | string |
| `virtualNetworkGatewayResourceId` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)
- [Publicipaddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/publicIPAddresses)
- [Virtualnetworkgateways](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/virtualNetworkGateways)

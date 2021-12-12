# Application Gateways `[Microsoft.Network/applicationGateways]`

This template deploys an application gateway.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/applicationGateways` | 2021-03-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backendHttpConfigurations` | array |  |  | Required. The backend HTTP settings to be configured. These HTTP settings will be used to rewrite the incoming HTTP requests for the backend pools. |
| `backendPools` | array |  |  | Required. The backend pools to be configured. |
| `capacity` | int | `2` |  | Optional. The number of Application instances to be configured. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `frontendHttpListeners` | array | `[]` |  | Required. The frontend http listeners to be configured. |
| `frontendHttpRedirects` | array | `[]` |  | Optional. The http redirects to be configured. Each redirect will route http traffic to a predefined frontEnd HTTPS listener. |
| `frontendHttpsListeners` | array | `[]` |  | Required. The frontend HTTPS listeners to be configured. |
| `frontendPrivateIpAddress` | string |  |  | Optional. The private IP within the Application Gateway subnet to be used as frontend private address. |
| `frontendPublicIpResourceId` | string |  |  | Required. PublicIP Resource ID used in Public Frontend. |
| `gatewayIpConfigurationName` | string | `gatewayIpConfiguration01` |  | Optional. Application Gateway IP configuration name. |
| `http2Enabled` | bool | `True` |  | Optional. Enables HTTP/2 support. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all Resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[ApplicationGatewayAccessLog, ApplicationGatewayPerformanceLog, ApplicationGatewayFirewallLog]` | `[ApplicationGatewayAccessLog, ApplicationGatewayPerformanceLog, ApplicationGatewayFirewallLog]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. The name to be used for the Application Gateway. |
| `probes` | array | `[]` |  | Optional. The backend HTTP settings probes to be configured. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `routingRules` | array |  |  | Required. The routing rules to be configured. These rules will be used to route requests from frontend listeners to backend pools using a backend HTTP configuration. |
| `sku` | string | `WAF_Medium` | `[Standard_Small, Standard_Medium, Standard_Large, WAF_Medium, WAF_Large, Standard_v2, WAF_v2]` | Optional. The name of the SKU for the Application Gateway. |
| `sslCertificateKeyVaultSecretId` | string |  |  | Optional. Secret ID of the SSL certificate stored in the Key Vault that will be used to configure the HTTPS listeners. |
| `sslCertificateName` | string | `sslCertificate01` |  | Optional. SSL certificate reference name for a certificate stored in the Key Vault to configure the HTTPS listeners. |
| `subnetName` | string |  |  | Required. The name of Gateway Subnet Name where the Application Gateway will be deployed. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `vNetName` | string |  |  | Required. The name of the Virtual Network where the Application Gateway will be deployed. |
| `vNetResourceGroup` | string | `[resourceGroup().name]` |  | Optional. The name of the Virtual Network Resource Group where the Application Gateway will be deployed. |
| `vNetSubscriptionId` | string | `[subscription().subscriptionId]` |  | Optional. The Subscription ID of the Virtual Network where the Application Gateway will be deployed. |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics. |

### Parameter Usage: `backendPools`

```json
"backendPools": {
    "value": [
        {
            "backendPoolName": "appServiceBackendPool",
            "backendAddresses": [
            {
                "fqdn": "aghapp.azurewebsites.net"
            }
            ]
        },
        {
            "backendPoolName": "privateVmBackendPool",
            "backendAddresses": [
            {
                "ipAddress": "10.0.0.4"
            }
            ]
        }
    ]
}
```

### Parameter Usage: `backendHttpConfigurations`

```json
"backendHttpConfigurations": {
    "value": [
        {
            "backendHttpConfigurationName": "appServiceBackendHttpsSetting",
            "port": 443,
            "protocol": "https",
            "cookieBasedAffinity": "Disabled",
            "pickHostNameFromBackendAddress": true,
            "probeEnabled": false
        },
        {
            "backendHttpConfigurationName": "privateVmHttpSetting",
            "port": 80,
            "protocol": "http",
            "cookieBasedAffinity": "Disabled",
            "pickHostNameFromBackendAddress": false,
            "probeEnabled": true
        }
    ]
}
```

### Parameter Usage: `probes`

```json
"probes": {
    "value": [
        {
          "backendHttpConfigurationName": "privateVmHttpSetting",
          "protocol": "http",
          "host": "10.0.0.4",
          "path": "/",
          "interval": 60,
          "timeout": 15,
          "unhealthyThreshold": 5,
          "minServers": 3,
          "statusCodes": [
            "200",
            "401"
          ]
        }
    ]
}
```

### Parameter Usage: `frontendHttpsListeners`

```json
"frontendHttpsListeners": {
    "value": [
        {
            "frontendListenerName": "public443",
            "frontendIPType": "Public",
            "port": 443
        },
        {
            "frontendListenerName": "private4433",
            "frontendIPType": "Private",
            "port": 4433
        }
    ]
}
```

### Parameter Usage: `frontendHttpRedirects`

```json
"frontendHttpRedirects": {
    "value": [
        {
            "frontendIPType": "Public",
            "port": 80,
            "frontendListenerName": "public443"
        },
        {
            "frontendIPType": "Private",
            "port": 8080,
            "frontendListenerName": "private4433"
        }
    ]
}
```

### Parameter Usage: `routingRules`

```json
"routingRules": {
    "value": [
        {
            "frontendListenerName": "public443",
            "backendPoolName": "appServiceBackendPool",
            "backendHttpConfigurationName": "appServiceBackendHttpsSetting"
        },
        {
            "frontendListenerName": "private4433",
            "backendPoolName": "privateVmBackendPool",
            "backendHttpConfigurationName": "privateVmHttpSetting"
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
| `applicationGatewayName` | string | The name of the application gateway |
| `applicationGatewayResourceGroup` | string | The resource group the application gateway was deployed into |
| `applicationGatewayResourceId` | string | The resource ID of the application gateway |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Applicationgateways](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-03-01/applicationGateways)

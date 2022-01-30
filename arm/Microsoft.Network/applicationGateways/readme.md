# Network Application Gateways `[Microsoft.Network/applicationGateways]`

This module deploys Network ApplicationGateways.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/applicationGateways` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authenticationCertificates` | array | `[]` |  | Optional. Authentication certificates of the application gateway resource. |
| `autoscaleMaxCapacity` | int | `10` |  | Optional. Upper bound on number of Application Gateway capacity. |
| `autoscaleMinCapacity` | int |  |  | Optional. Lower bound on number of Application Gateway capacity. |
| `backendAddressPools` | array | `[]` |  | Optional. Backend address pool of the application gateway resource. |
| `backendHttpSettingsCollection` | array | `[]` |  | Optional. Backend http settings of the application gateway resource. |
| `capacity` | int | `2` |  | Optional. The number of Application instances to be configured. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `customErrorConfigurations` | array | `[]` |  | Optional. Custom error configurations of the application gateway resource. |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.  |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `enableFips` | bool |  |  | Optional. Whether FIPS is enabled on the application gateway resource. |
| `enableHttp2` | bool |  |  | Optional. Whether HTTP2 is enabled on the application gateway resource. |
| `enableRequestBuffering` | bool |  |  | Optional. Enable request buffering. |
| `enableResponseBuffering` | bool |  |  | Optional. Enable response buffering. |
| `firewallPolicyId` | string |  |  | Optional. The resource Id of an associated firewall policy. |
| `frontendIPConfigurations` | array | `[]` |  | Optional. Frontend IP addresses of the application gateway resource. |
| `frontendPorts` | array | `[]` |  | Optional. Frontend ports of the application gateway resource. |
| `gatewayIPConfigurations` | array | `[]` |  | Optional. Subnets of the application gateway resource. |
| `httpListeners` | array | `[]` |  | Optional. Http listeners of the application gateway resource. |
| `loadDistributionPolicies` | array | `[]` |  | Optional. Load distribution policies of the application gateway resource. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[ApplicationGatewayAccessLog, ApplicationGatewayPerformanceLog, ApplicationGatewayFirewallLog]` | `[ApplicationGatewayAccessLog, ApplicationGatewayPerformanceLog, ApplicationGatewayFirewallLog]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. Name of the Application Gateway. |
| `privateLinkConfigurations` | array | `[]` |  | Optional. PrivateLink configurations on application gateway. |
| `probes` | array | `[]` |  | Optional. Probes of the application gateway resource. |
| `redirectConfigurations` | array | `[]` |  | Optional. Redirect configurations of the application gateway resource. |
| `requestRoutingRules` | array | `[]` |  | Optional. Request routing rules of the application gateway resource. |
| `rewriteRuleSets` | array | `[]` |  | Optional. Rewrite rules for the application gateway resource.	 |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sku` | string | `WAF_Medium` | `[Standard_Small, Standard_Medium, Standard_Large, WAF_Medium, WAF_Large, Standard_v2, WAF_v2]` | Optional. The name of the SKU for the Application Gateway. |
| `sslCertificates` | array | `[]` |  | Optional. SSL certificates of the application gateway resource. |
| `sslPolicyCipherSuites` | array | `[TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256]` | `[TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA, TLS_DHE_DSS_WITH_AES_128_CBC_SHA, TLS_DHE_DSS_WITH_AES_128_CBC_SHA256, TLS_DHE_DSS_WITH_AES_256_CBC_SHA, TLS_DHE_DSS_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA, TLS_DHE_RSA_WITH_AES_128_GCM_SHA256, TLS_DHE_RSA_WITH_AES_256_CBC_SHA, TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_3DES_EDE_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA256, TLS_RSA_WITH_AES_128_GCM_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA, TLS_RSA_WITH_AES_256_CBC_SHA256, TLS_RSA_WITH_AES_256_GCM_SHA384]` | Optional. Ssl cipher suites to be enabled in the specified order to application gateway. |
<!-- | `sslPolicyDisabledSslProtocols` | array | `[]` | `[TLSv1_0, TLSv1_1, TLSv1_2]` | Optional. Ssl protocols to be disabled on application gateway. | -->
| `sslPolicyMinProtocolVersion` | string | `TLSv1_2` | `[TLSv1_0, TLSv1_1, TLSv1_2]` | Optional. Ssl protocol enums. |
| `sslPolicyName` | string |  | `[AppGwSslPolicy20150501, AppGwSslPolicy20170401, AppGwSslPolicy20170401S, ]` | Optional. Ssl predefined policy name enums. |
| `sslPolicyType` | string | `Custom` | `[Custom, Predefined]` | Optional. Type of Ssl Policy. |
| `sslProfiles` | array | `[]` |  | Optional. SSL profiles of the application gateway resource. |
| `tags` | object | `{object}` |  | Optional. Resource tags. |
| `trustedClientCertificates` | array | `[]` |  | Optional. Trusted client certificates of the application gateway resource. |
| `trustedRootCertificates` | array | `[]` |  | Optional. Trusted Root certificates of the application gateway resource. |
| `urlPathMaps` | array | `[]` |  | Optional. URL path map of the application gateway resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `webApplicationFirewallConfiguration` | object | `{object}` |  | Optional. Application gateway web application firewall configuration. |
| `zones` | array | `[]` |  | Optional. A list of availability zones denoting where the resource needs to come from. |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

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
| `name` | string | The name of the application gateway |
| `resourceGroupName` | string | The resource group the application gateway was deployed into |
| `resourceId` | string | The resource ID of the application gateway |

## Template references

- [Applicationgateways](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/applicationGateways)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)

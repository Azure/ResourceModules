# Api Management `[Microsoft.ApiManagement/service]`

This module deploys an API management.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service` | 2020-12-01 |
| `Microsoft.ApiManagement/service/identityProviders` | 2020-06-01-preview |
| `Microsoft.ApiManagement/service/policies` | 2020-06-01-preview |
| `Microsoft.ApiManagement/service/portalsettings` | 2019-12-01 |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalLocations` | array | `[]` |  | Optional. Additional datacenter locations of the API Management service. |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the Api Management service. |
| `apiManagementServicePolicy` | object | `{object}` |  | Optional. Policy content for the Api Management Service. Format: Format of the policyContent. - xml, xml-link, rawxml, rawxml-link. Value: Contents of the Policy as defined by the format. |
| `certificates` | array | `[]` |  | Optional. List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `customProperties` | object | `{object}` |  | Optional. Custom properties of the API Management service. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `disableGateway` | bool |  |  | Optional. Property only valid for an Api Management service deployed in multiple locations. This can be used to disable the gateway in master region. |
| `enableClientCertificate` | bool |  |  | Optional. Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway. |
| `enableIdentityProviders` | bool |  |  | Optional. Used to enable the deployment of the identityProviders child resource. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `hostnameConfigurations` | array | `[]` |  | Optional. Custom hostname configuration of the API Management service. |
| `identity` | object | `{object}` |  | Optional. Managed service identity of the Api Management service. |
| `identityProviderAllowedTenants` | array | `[]` |  | Optional. List of Allowed Tenants when configuring Azure Active Directory login. - string |
| `identityProviderAuthority` | string |  |  | Optional. OpenID Connect discovery endpoint hostname for AAD or AAD B2C. |
| `identityProviderClientId` | string |  |  | Optional. Client Id of the Application in the external Identity Provider. Required if identity provider is used. |
| `identityProviderClientSecret` | secureString |  |  | Optional. Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used. |
| `identityProviderPasswordResetPolicyName` | string |  |  | Optional. Password Reset Policy Name. Only applies to AAD B2C Identity Provider. |
| `identityProviderProfileEditingPolicyName` | string |  |  | Optional. Profile Editing Policy Name. Only applies to AAD B2C Identity Provider. |
| `identityProviderSignInPolicyName` | string |  |  | Optional. Signin Policy Name. Only applies to AAD B2C Identity Provider. |
| `identityProviderSignInTenant` | string |  |  | Optional. The TenantId to use instead of Common when logging into Active Directory |
| `identityProviderSignUpPolicyName` | string |  |  | Optional. Signup Policy Name. Only applies to AAD B2C Identity Provider. |
| `identityProviderType` | string | `aad` | `[aad, aadB2C, facebook, google, microsoft, twitter]` | Optional. Identity Provider Type identifier. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all Resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[GatewayLogs]` | `[GatewayLogs]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `minApiVersion` | string |  |  | Optional. Limit control plane API calls to API Management service with version equal to or newer than this value. |
| `notificationSenderEmail` | string | `apimgmt-noreply@mail.windowsazure.com` |  | Optional. The notification sender email address for the service. |
| `portalSignIn` | object | `{object}` |  | Optional. Portal sign in settings. |
| `portalSignUp` | object | `{object}` |  | Optional. Portal sign up settings. |
| `publisherEmail` | string |  |  | Required. The email address of the owner of the service. |
| `publisherName` | string |  |  | Required. The name of the owner of the service. |
| `restore` | bool |  |  | Optional. Undelete Api Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sku` | string | `Developer` | `[Consumption, Developer, Basic, Standard, Premium]` | Optional. The pricing tier of this Api Management service. |
| `skuCount` | int | `1` | `[1, 2]` | Optional. The instance size of this Api Management service. |
| `subnetResourceId` | string |  |  | Optional. The full resource ID of a subnet in a virtual network to deploy the API Management service in. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `virtualNetworkType` | string | `None` | `[None, External, Internal]` | Optional. The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an Internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |
| `zones` | array | `[]` |  | Optional. A list of availability zones denoting where the resource needs to come from. |

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

```Json
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

### Parameter Usage: `apiManagementServicePolicy`

```Json
"apiManagementServicePolicy": {
    "value": {
        "value":"<policies> <inbound> <rate-limit-by-key calls='250' renewal-period='60' counter-key='@(context.Request.IpAddress)' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>",
        "format":"xml"
    }
}
```

## Outputs

| Output Name | Type |
| :-- | :-- |
| `apimServiceName` | string |
| `apimServiceResourceGroup` | string |
| `apimServiceResourceId` | string |

## Considerations

- *None*

## Template references

- [Service](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-12-01/service)
- [Service/Identityproviders](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/identityProviders)
- [Service/Policies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2020-06-01-preview/service/policies)
- [Service/Portalsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2019-12-01/service/portalsettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)

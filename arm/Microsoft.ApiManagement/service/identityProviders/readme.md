# API Management Service Identity Providers `[Microsoft.ApiManagement/service/identityProviders]`

This module deploys API Management Service Identity Provider.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/identityProviders` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  |  | Required. The name of the of the API Management service. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `enableIdentityProviders` | bool |  |  | Optional. Used to enable the deployment of the identityProviders child resource. |
| `identityProviderAllowedTenants` | array | `[]` |  | Optional. List of Allowed Tenants when configuring Azure Active Directory login. - string |
| `identityProviderAuthority` | string |  |  | Optional. OpenID Connect discovery endpoint hostname for AAD or AAD B2C. |
| `identityProviderClientId` | string |  |  | Optional. Client ID of the Application in the external Identity Provider. Required if identity provider is used. |
| `identityProviderClientSecret` | secureString |  |  | Optional. Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used. |
| `identityProviderPasswordResetPolicyName` | string |  |  | Optional. Password Reset Policy Name. Only applies to AAD B2C Identity Provider. |
| `identityProviderProfileEditingPolicyName` | string |  |  | Optional. Profile Editing Policy Name. Only applies to AAD B2C Identity Provider. |
| `identityProviderSignInPolicyName` | string |  |  | Optional. Signin Policy Name. Only applies to AAD B2C Identity Provider. |
| `identityProviderSignInTenant` | string |  |  | Optional. The TenantId to use instead of Common when logging into Active Directory |
| `identityProviderSignUpPolicyName` | string |  |  | Optional. Signup Policy Name. Only applies to AAD B2C Identity Provider. |
| `identityProviderType` | string | `aad` | `[aad, aadB2C, facebook, google, microsoft, twitter]` | Optional. Identity Provider Type identifier. |
| `name` | string |  |  | Required. Identity provider name |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service identity provider |
| `resourceGroupName` | string | The resource group the API management service identity provider was deployed into |
| `resourceId` | string | The resource ID of the API management service identity provider |

## Template references

- [Service/Identityproviders](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/identityProviders)

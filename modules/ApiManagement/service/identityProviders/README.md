# API Management Service Identity Providers `[Microsoft.ApiManagement/service/identityProviders]`

This module deploys API Management Service Identity Provider.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/identityProviders` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/identityProviders) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Identity provider name. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `apiManagementServiceName` | string |  | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| `clientId` | string | `''` | Client ID of the Application in the external Identity Provider. Required if identity provider is used. |
| `clientSecret` | securestring | `''` | Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowedTenants` | array | `[]` |  | List of Allowed Tenants when configuring Azure Active Directory login. - string. |
| `authority` | string | `''` |  | OpenID Connect discovery endpoint hostname for AAD or AAD B2C. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableIdentityProviders` | bool | `False` |  | Used to enable the deployment of the identityProviders child resource. |
| `passwordResetPolicyName` | string | `''` |  | Password Reset Policy Name. Only applies to AAD B2C Identity Provider. |
| `profileEditingPolicyName` | string | `''` |  | Profile Editing Policy Name. Only applies to AAD B2C Identity Provider. |
| `signInPolicyName` | string | `''` |  | Signin Policy Name. Only applies to AAD B2C Identity Provider. |
| `signInTenant` | string | `''` |  | The TenantId to use instead of Common when logging into Active Directory. |
| `signUpPolicyName` | string | `''` |  | Signup Policy Name. Only applies to AAD B2C Identity Provider. |
| `type` | string | `'aad'` | `[aad, aadB2C, facebook, google, microsoft, twitter]` | Identity Provider Type identifier. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service identity provider. |
| `resourceGroupName` | string | The resource group the API management service identity provider was deployed into. |
| `resourceId` | string | The resource ID of the API management service identity provider. |

## Cross-referenced modules

_None_

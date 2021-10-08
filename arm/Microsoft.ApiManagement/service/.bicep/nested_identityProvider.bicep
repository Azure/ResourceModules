param variables_isAadB2C bool

@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Optional. Identity Provider Type identifier. - aad , aadB2C')
param identityProviderType string

@description('Optional. The TenantId to use instead of Common when logging into Active Directory')
param identityProviderSignInTenant string

@description('Optional. List of Allowed Tenants when configuring Azure Active Directory login. - string')
param identityProviderAllowedTenants array

@description('Optional. OpenID Connect discovery endpoint hostname for AAD or AAD B2C.')
param identityProviderAuthority string

@description('Optional. Signup Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderSignUpPolicyName string

@description('Optional. Signin Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderSignInPolicyName string

@description('Optional. Profile Editing Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderProfileEditingPolicyName string

@description('Optional. Password Reset Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderPasswordResetPolicyName string

@description('Optional. Client Id of the Application in the external Identity Provider. Required if identity provider is used.')
param identityProviderClientId string

@description('Optional. Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used.')
@secure()
param identityProviderClientSecret string

resource apiManagementService_identityProviderType 'Microsoft.ApiManagement/service/identityProviders@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/${identityProviderType}'
  properties: {
    type: identityProviderType
    signinTenant: identityProviderSignInTenant
    allowedTenants: identityProviderAllowedTenants
    authority: identityProviderAuthority
    signupPolicyName: (variables_isAadB2C ? identityProviderSignUpPolicyName : json('null'))
    signinPolicyName: (variables_isAadB2C ? identityProviderSignInPolicyName : json('null'))
    profileEditingPolicyName: (variables_isAadB2C ? identityProviderProfileEditingPolicyName : json('null'))
    passwordResetPolicyName: (variables_isAadB2C ? identityProviderPasswordResetPolicyName : json('null'))
    clientId: identityProviderClientId
    clientSecret: identityProviderClientSecret
  }
}

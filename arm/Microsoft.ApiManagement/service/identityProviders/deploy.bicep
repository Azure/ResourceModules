@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Used to enable the deployment of the identityProviders child resource.')
param enableIdentityProviders bool = false

@description('Optional. List of Allowed Tenants when configuring Azure Active Directory login. - string.')
param identityProviderAllowedTenants array = []

@description('Optional. OpenID Connect discovery endpoint hostname for AAD or AAD B2C.')
param identityProviderAuthority string = ''

@description('Conditional. Client ID of the Application in the external Identity Provider. Required if identity provider is used.')
param identityProviderClientId string = ''

@description('Conditional. Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used.')
@secure()
param identityProviderClientSecret string = ''

@description('Optional. Password Reset Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderPasswordResetPolicyName string = ''

@description('Optional. Profile Editing Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderProfileEditingPolicyName string = ''

@description('Optional. Signin Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderSignInPolicyName string = ''

@description('Optional. The TenantId to use instead of Common when logging into Active Directory.')
param identityProviderSignInTenant string = ''

@description('Optional. Signup Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderSignUpPolicyName string = ''

@description('Optional. Identity Provider Type identifier.')
@allowed([
  'aad'
  'aadB2C'
  'facebook'
  'google'
  'microsoft'
  'twitter'
])
param identityProviderType string = 'aad'

@description('Required. Identity provider name.')
param name string

var isAadB2C = (identityProviderType == 'aadB2C')

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource identityProvider 'Microsoft.ApiManagement/service/identityProviders@2021-08-01' = if (enableIdentityProviders) {
  name: name
  parent: service
  properties: {
    type: identityProviderType
    signinTenant: identityProviderSignInTenant
    allowedTenants: identityProviderAllowedTenants
    authority: identityProviderAuthority
    signupPolicyName: isAadB2C ? identityProviderSignUpPolicyName : null
    signinPolicyName: isAadB2C ? identityProviderSignInPolicyName : null
    profileEditingPolicyName: isAadB2C ? identityProviderProfileEditingPolicyName : null
    passwordResetPolicyName: isAadB2C ? identityProviderPasswordResetPolicyName : null
    clientId: identityProviderClientId
    clientSecret: identityProviderClientSecret
  }
}

@description('The resource ID of the API management service identity provider.')
output resourceId string = identityProvider.id

@description('The name of the API management service identity provider.')
output name string = identityProvider.name

@description('The resource group the API management service identity provider was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('Optional. Additional datacenter locations of the API Management service.')
param additionalLocations array = []

@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Optional. Policy content for the Api Management Service. Format: Format of the policyContent. - xml, xml-link, rawxml, rawxml-link. Value: Contents of the Policy as defined by the format.')
param apiManagementServicePolicy object = {}

@description('Optional. List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.')
@maxLength(10)
param certificates array = []

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Custom properties of the API Management service.')
param customProperties object = {}

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Property only valid for an Api Management service deployed in multiple locations. This can be used to disable the gateway in master region.')
param disableGateway bool = false

@description('Optional. Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway.')
param enableClientCertificate bool = false

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@description('Optional. Custom hostname configuration of the API Management service.')
param hostnameConfigurations array = []

@description('Optional. Managed service identity of the Api Management service.')
param identity object = {}

@description('Optional. Used to enable the deployment of the identityProviders child resource.')
param enableIdentityProviders bool = false

@description('Optional. List of Allowed Tenants when configuring Azure Active Directory login. - string')
param identityProviderAllowedTenants array = []

@description('Optional. OpenID Connect discovery endpoint hostname for AAD or AAD B2C.')
param identityProviderAuthority string = ''

@description('Optional. Client Id of the Application in the external Identity Provider. Required if identity provider is used.')
param identityProviderClientId string = ''

@description('Optional. Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used.')
@secure()
param identityProviderClientSecret string = ''

@description('Optional. Password Reset Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderPasswordResetPolicyName string = ''

@description('Optional. Profile Editing Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderProfileEditingPolicyName string = ''

@description('Optional. Signin Policy Name. Only applies to AAD B2C Identity Provider.')
param identityProviderSignInPolicyName string = ''

@description('Optional. The TenantId to use instead of Common when logging into Active Directory')
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

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Limit control plane API calls to API Management service with version equal to or newer than this value.')
param minApiVersion string = ''

@description('Optional. The notification sender email address for the service.')
param notificationSenderEmail string = 'apimgmt-noreply@mail.windowsazure.com'

@description('Optional. Portal sign in settings.')
param portalSignIn object = {}

@description('Optional. Portal sign up settings.')
param portalSignUp object = {}

@description('Required. The email address of the owner of the service.')
param publisherEmail string

@description('Required. The name of the owner of the service.')
param publisherName string

@description('Optional. Undelete Api Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored.')
param restore bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. The pricing tier of this Api Management service.')
@allowed([
  'Consumption'
  'Developer'
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Developer'

@description('Optional. The instance size of this Api Management service.')
@allowed([
  1
  2
])
param skuCount int = 1

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the API Management service in.')
param subnetResourceId string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an Internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.')
@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'

@description('Optional. Resource identifier of Log Analytics.')
param workspaceId string = ''

@description('Optional. A list of availability zones denoting where the resource needs to come from.')
param zones array = []

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'GatewayLogs'
])
param logsToEnable array = [
  'GatewayLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var isAadB2C = (identityProviderType == 'aadB2C')

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource apiManagementService 'Microsoft.ApiManagement/service@2020-12-01' = {
  name: apiManagementServiceName
  location: location
  tags: tags
  sku: {
    name: sku
    capacity: skuCount
  }
  zones: zones
  identity: ((!empty(identity)) ? identity : json('{"type": "None"}'))
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    notificationSenderEmail: notificationSenderEmail
    hostnameConfigurations: hostnameConfigurations
    additionalLocations: additionalLocations
    customProperties: customProperties
    certificates: certificates
    enableClientCertificate: (enableClientCertificate ? true : json('null'))
    disableGateway: disableGateway
    virtualNetworkType: virtualNetworkType
    virtualNetworkConfiguration: ((!empty(subnetResourceId)) ? json('{"subnetResourceId": "${subnetResourceId}"}') : json('null'))
    apiVersionConstraint: ((!empty(minApiVersion)) ? json('{"minApiVersion": "${minApiVersion}"}') : json('null'))
    restore: restore
  }
  resource apiManagementService_signin 'portalsettings@2019-12-01' = if (!empty(portalSignIn)) {
    name: 'signin'
    properties: portalSignIn
  }
  resource apiManagementService_signup 'portalsettings@2019-12-01' = if (!empty(portalSignUp)) {
    name: 'signup'
    properties: portalSignUp
  }
  resource apiManagementService_policy 'policies@2020-06-01-preview' = if (!empty(apiManagementServicePolicy)) {
    name: 'policy'
    properties: apiManagementServicePolicy
  }
  resource apiManagementService_identityProvider 'identityProviders@2020-06-01-preview' = if (enableIdentityProviders) {
    name: identityProviderType
    properties: {
      type: identityProviderType
      signinTenant: identityProviderSignInTenant
      allowedTenants: identityProviderAllowedTenants
      authority: identityProviderAuthority
      signupPolicyName: (isAadB2C ? identityProviderSignUpPolicyName : json('null'))
      signinPolicyName: (isAadB2C ? identityProviderSignInPolicyName : json('null'))
      profileEditingPolicyName: (isAadB2C ? identityProviderProfileEditingPolicyName : json('null'))
      passwordResetPolicyName: (isAadB2C ? identityProviderPasswordResetPolicyName : json('null'))
      clientId: identityProviderClientId
      clientSecret: identityProviderClientSecret
    }
  }
}

resource apiManagementService_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${apiManagementService.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: apiManagementService
}

resource apiManagementService_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${apiManagementService.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: apiManagementService
}

module apiManagementService_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: apiManagementService.name
  }
}]

output apimServiceName string = apiManagementService.name
output apimServiceResourceId string = apiManagementService.id
output apimServiceResourceGroup string = resourceGroup().name

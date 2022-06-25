@description('Optional. Additional datacenter locations of the API Management service.')
param additionalLocations array = []

@description('Required. The name of the API Management service.')
param name string

@description('Optional. List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.')
@maxLength(10)
param certificates array = []

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Custom properties of the API Management service.')
param customProperties object = {}

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region.')
param disableGateway bool = false

@description('Optional. Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway.')
param enableClientCertificate bool = false

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Custom hostname configuration of the API Management service.')
param hostnameConfigurations array = []

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Limit control plane API calls to API Management service with version equal to or newer than this value.')
param minApiVersion string = ''

@description('Optional. The notification sender email address for the service.')
param notificationSenderEmail string = 'apimgmt-noreply@mail.windowsazure.com'

@description('Required. The email address of the owner of the service.')
param publisherEmail string

@description('Required. The name of the owner of the service.')
param publisherName string

@description('Optional. Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored.')
param restore bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. The pricing tier of this API Management service.')
@allowed([
  'Consumption'
  'Developer'
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Developer'

@description('Optional. The instance size of this API Management service.')
@allowed([
  1
  2
])
param skuCount int = 1

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the API Management service in.')
param subnetResourceId string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.')
@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. A list of availability zones denoting where the resource needs to come from.')
param zones array = []

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'GatewayLogs'
])
param diagnosticLogCategoriesToEnable array = [
  'GatewayLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]
@description('Optional. Necessary to create a new GUID.')
param newGuidValue string = newGuid()

@description('Optional. APIs.')
param apis array = []
@description('Optional. API Version Sets.')
param apiVersionSets array = []
@description('Optional. Authorization servers.')
param authorizationServers array = []
@description('Optional. Backends.')
param backends array = []
@description('Optional. Caches.')
param caches array = []
@description('Optional. Identity providers.')
param identityProviders array = []
@description('Optional. Named values.')
param namedValues array = []
@description('Optional. Policies.')
param policies array = []
@description('Optional. Portal settings.')
param portalSettings array = []
@description('Optional. Products.')
param products array = []
@description('Optional. Subscriptions.')
param subscriptions array = []

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

var enableReferencedModulesTelemetry = false

var diagnosticsLogs = [for category in diagnosticLogCategoriesToEnable: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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

resource apiManagementService 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    capacity: skuCount
  }
  zones: zones
  identity: identity
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    notificationSenderEmail: notificationSenderEmail
    hostnameConfigurations: hostnameConfigurations
    additionalLocations: additionalLocations
    customProperties: customProperties
    certificates: certificates
    enableClientCertificate: enableClientCertificate ? true : null
    disableGateway: disableGateway
    virtualNetworkType: virtualNetworkType
    virtualNetworkConfiguration: !empty(subnetResourceId) ? json('{"subnetResourceId": "${subnetResourceId}"}') : null
    apiVersionConstraint: !empty(minApiVersion) ? json('{"minApiVersion": "${minApiVersion}"}') : null
    restore: restore
  }
}

module apis_resource 'apis/deploy.bicep' = [for (api, index) in apis: {
  name: '${uniqueString(deployment().name, location)}-Apim-Api-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    displayName: api.displayName
    name: api.name
    path: api.path
    apiDescription: contains(api, 'apiDescription') ? api.apiDescription : ''
    apiRevision: contains(api, 'apiRevision') ? api.apiRevision : ''
    apiRevisionDescription: contains(api, 'apiRevisionDescription') ? api.apiRevisionDescription : ''
    apiType: contains(api, 'apiType') ? api.apiType : 'http'
    apiVersion: contains(api, 'apiVersion') ? api.apiVersion : ''
    apiVersionDescription: contains(api, 'apiVersionDescription') ? api.apiVersionDescription : ''
    apiVersionSetId: contains(api, 'apiVersionSetId') ? api.apiVersionSetId : ''
    authenticationSettings: contains(api, 'authenticationSettings') ? api.authenticationSettings : {}
    format: contains(api, 'format') ? api.format : 'openapi'
    isCurrent: contains(api, 'isCurrent') ? api.isCurrent : true
    protocols: contains(api, 'protocols') ? api.protocols : [
      'https'
    ]
    policies: contains(api, 'policies') ? api.policies : []
    serviceUrl: contains(api, 'serviceUrl') ? api.serviceUrl : ''
    sourceApiId: contains(api, 'sourceApiId') ? api.sourceApiId : ''
    subscriptionKeyParameterNames: contains(api, 'subscriptionKeyParameterNames') ? api.subscriptionKeyParameterNames : {}
    subscriptionRequired: contains(api, 'subscriptionRequired') ? api.subscriptionRequired : false
    type: contains(api, 'type') ? api.type : 'http'
    value: contains(api, 'value') ? api.value : ''
    wsdlSelector: contains(api, 'wsdlSelector') ? api.wsdlSelector : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    apiVersionSet_resource
  ]
}]

module apiVersionSet_resource 'apiVersionSets/deploy.bicep' = [for (apiVersionSet, index) in apiVersionSets: {
  name: '${uniqueString(deployment().name, location)}-Apim-ApiVersionSet-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    name: apiVersionSet.name
    properties: contains(apiVersionSet, 'properties') ? apiVersionSet.properties : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module authorizationServers_resource '.bicep/nested_authorizationServers.bicep' = [for (authorizationServer, index) in authorizationServers: {
  name: '${uniqueString(deployment().name, location)}-Apim-AuthorizationServer-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    name: authorizationServer.name
    authorizationEndpoint: authorizationServer.authorizationEndpoint
    authorizationMethods: contains(authorizationServer, 'authorizationMethods') ? authorizationServer.authorizationMethods : [
      'GET'
    ]
    bearerTokenSendingMethods: contains(authorizationServer, 'bearerTokenSendingMethods') ? authorizationServer.bearerTokenSendingMethods : [
      'authorizationHeader'
    ]
    clientAuthenticationMethod: contains(authorizationServer, 'clientAuthenticationMethod') ? authorizationServer.clientAuthenticationMethod : [
      'Basic'
    ]
    clientCredentialsKeyVaultId: authorizationServer.clientCredentialsKeyVaultId
    clientIdSecretName: authorizationServer.clientIdSecretName
    clientSecretSecretName: authorizationServer.clientSecretSecretName
    clientRegistrationEndpoint: contains(authorizationServer, 'clientRegistrationEndpoint') ? authorizationServer.clientRegistrationEndpoint : ''
    defaultScope: contains(authorizationServer, 'defaultScope') ? authorizationServer.defaultScope : ''
    grantTypes: authorizationServer.grantTypes
    resourceOwnerPassword: contains(authorizationServer, 'resourceOwnerPassword') ? authorizationServer.resourceOwnerPassword : ''
    resourceOwnerUsername: contains(authorizationServer, 'resourceOwnerUsername') ? authorizationServer.resourceOwnerUsername : ''
    serverDescription: contains(authorizationServer, 'serverDescription') ? authorizationServer.serverDescription : ''
    supportState: contains(authorizationServer, 'supportState') ? authorizationServer.supportState : false
    tokenBodyParameters: contains(authorizationServer, 'tokenBodyParameters') ? authorizationServer.tokenBodyParameters : []
    tokenEndpoint: contains(authorizationServer, 'tokenEndpoint') ? authorizationServer.tokenEndpoint : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module backends_resource 'backends/deploy.bicep' = [for (backend, index) in backends: {
  name: '${uniqueString(deployment().name, location)}-Apim-Backend-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    url: contains(backend, 'url') ? backend.url : ''
    backendDescription: contains(backend, 'backendDescription') ? backend.backendDescription : ''
    credentials: contains(backend, 'credentials') ? backend.credentials : {}
    name: backend.name
    protocol: contains(backend, 'protocol') ? backend.protocol : 'http'
    proxy: contains(backend, 'proxy') ? backend.proxy : {}
    resourceId: contains(backend, 'resourceId') ? backend.resourceId : ''
    serviceFabricCluster: contains(backend, 'serviceFabricCluster') ? backend.serviceFabricCluster : {}
    title: contains(backend, 'title') ? backend.title : ''
    tls: contains(backend, 'tls') ? backend.tls : {
      validateCertificateChain: false
      validateCertificateName: false
    }
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module caches_resource 'caches/deploy.bicep' = [for (cache, index) in caches: {
  name: '${uniqueString(deployment().name, location)}-Apim-Cache-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    cacheDescription: contains(cache, 'cacheDescription') ? cache.cacheDescription : ''
    connectionString: cache.connectionString
    name: cache.name
    resourceId: contains(cache, 'resourceId') ? cache.resourceId : ''
    useFromLocation: cache.useFromLocation
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module identityProvider_resource 'identityProviders/deploy.bicep' = [for (identityProvider, index) in identityProviders: {
  name: '${uniqueString(deployment().name, location)}-Apim-IdentityProvider-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    name: identityProvider.name
    enableIdentityProviders: contains(identityProvider, 'enableIdentityProviders') ? identityProvider.enableIdentityProviders : false
    identityProviderAllowedTenants: contains(identityProvider, 'identityProviderAllowedTenants') ? identityProvider.identityProviderAllowedTenants : []
    identityProviderAuthority: contains(identityProvider, 'identityProviderAuthority') ? identityProvider.identityProviderAuthority : ''
    identityProviderClientId: contains(identityProvider, 'identityProviderClientId') ? identityProvider.identityProviderClientId : ''
    identityProviderClientSecret: contains(identityProvider, 'identityProviderClientSecret') ? identityProvider.identityProviderClientSecret : ''
    identityProviderPasswordResetPolicyName: contains(identityProvider, 'identityProviderPasswordResetPolicyName') ? identityProvider.identityProviderPasswordResetPolicyName : ''
    identityProviderProfileEditingPolicyName: contains(identityProvider, 'identityProviderProfileEditingPolicyName') ? identityProvider.identityProviderProfileEditingPolicyName : ''
    identityProviderSignInPolicyName: contains(identityProvider, 'identityProviderSignInPolicyName') ? identityProvider.identityProviderSignInPolicyName : ''
    identityProviderSignInTenant: contains(identityProvider, 'identityProviderSignInTenant') ? identityProvider.identityProviderSignInTenant : ''
    identityProviderSignUpPolicyName: contains(identityProvider, 'identityProviderSignUpPolicyName') ? identityProvider.identityProviderSignUpPolicyName : ''
    identityProviderType: contains(identityProvider, 'identityProviderType') ? identityProvider.identityProviderType : 'aad'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module namedValues_resource 'namedValues/deploy.bicep' = [for (namedValue, index) in namedValues: {
  name: '${uniqueString(deployment().name, location)}-Apim-NamedValue-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    displayName: namedValue.displayName
    keyVault: contains(namedValue, 'keyVault') ? namedValue.keyVault : {}
    name: namedValue.name
    namedValueTags: contains(namedValue, 'namedValueTags') ? namedValue.namedValueTags : []
    secret: contains(namedValue, 'secret') ? namedValue.secret : false
    value: contains(namedValue, 'value') ? namedValue.value : newGuidValue
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module portalSettings_resource 'portalsettings/deploy.bicep' = [for (portalSetting, index) in portalSettings: {
  name: '${uniqueString(deployment().name, location)}-Apim-PortalSetting-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    name: portalSetting.name
    properties: contains(portalSetting, 'properties') ? portalSetting.properties : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module policy_resource 'policies/deploy.bicep' = [for (policy, index) in policies: {
  name: '${uniqueString(deployment().name, location)}-Apim-Policy-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    value: policy.value
    format: contains(policy, 'format') ? policy.format : 'xml'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module products_resource 'products/deploy.bicep' = [for (product, index) in products: {
  name: '${uniqueString(deployment().name, location)}-Apim-Product-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    apis: contains(product, 'apis') ? product.apis : []
    approvalRequired: contains(product, 'approvalRequired') ? product.approvalRequired : false
    groups: contains(product, 'groups') ? product.groups : []
    name: product.name
    productDescription: contains(product, 'productDescription') ? product.productDescription : ''
    state: contains(product, 'state') ? product.state : 'published'
    subscriptionRequired: contains(product, 'subscriptionRequired') ? product.subscriptionRequired : false
    subscriptionsLimit: contains(product, 'subscriptionsLimit') ? product.subscriptionsLimit : 1
    terms: contains(product, 'terms') ? product.terms : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    apis_resource
  ]
}]

module subscriptions_resource 'subscriptions/deploy.bicep' = [for (subscription, index) in subscriptions: {
  name: '${uniqueString(deployment().name, location)}-Apim-Subscription-${index}'
  params: {
    apiManagementServiceName: apiManagementService.name
    name: contains(subscription, 'name') ? subscription.name : ''
    allowTracing: contains(subscription, 'allowTracing') ? subscription.allowTracing : false
    ownerId: contains(subscription, 'ownerId') ? subscription.ownerId : ''
    primaryKey: contains(subscription, 'primaryKey') ? subscription.primaryKey : ''
    scope: contains(subscription, 'scope') ? subscription.scope : '/apis'
    secondaryKey: contains(subscription, 'secondaryKey') ? subscription.secondaryKey : ''
    state: contains(subscription, 'state') ? subscription.state : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource apiManagementService_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${apiManagementService.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: apiManagementService
}

resource apiManagementService_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: apiManagementService
}

module apiManagementService_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Apim-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: apiManagementService.id
  }
}]

@description('The name of the API management service.')
output name string = apiManagementService.name

@description('The resource ID of the API management service.')
output resourceId string = apiManagementService.id

@description('The resource group the API management service was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(apiManagementService.identity, 'principalId') ? apiManagementService.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = apiManagementService.location

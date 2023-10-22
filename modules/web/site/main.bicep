metadata name = 'Web/Function Apps'
metadata description = 'This module deploys a Web or Function App.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the site.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. Type of site to deploy.')
@allowed([
  'functionapp' // function app windows os
  'functionapp,linux' // function app linux os
  'functionapp,workflowapp' // logic app workflow
  'functionapp,workflowapp,linux' // logic app docker container
  'app' // normal web app
])
param kind string

@description('Required. The resource ID of the app service plan to use for the site.')
param serverFarmResourceId string

@description('Optional. Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests.')
param httpsOnly bool = true

@description('Optional. If client affinity is enabled.')
param clientAffinityEnabled bool = true

@description('Optional. The resource ID of the app service environment to use for this resource.')
param appServiceEnvironmentResourceId string = ''

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. The resource ID of the assigned identity to be used to access a key vault with.')
param keyVaultAccessIdentityResourceId string = ''

@description('Optional. Checks if Customer provided storage account is required.')
param storageAccountRequired bool = false

@description('Optional. Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}.')
param virtualNetworkSubnetId string = ''

@description('Optional. To enable accessing content over virtual network.')
param vnetContentShareEnabled bool = false

@description('Optional. To enable pulling image over Virtual Network.')
param vnetImagePullEnabled bool = false

@description('Optional. Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied.')
param vnetRouteAllEnabled bool = false

@description('Optional. Stop SCM (KUDU) site when the app is stopped.')
param scmSiteAlsoStopped bool = false

@description('Optional. The site config object.')
param siteConfig object = {}

@description('Optional. Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.')
param storageAccountResourceId string = ''

@description('Optional. Resource ID of the app insight to leverage for this resource.')
param appInsightResourceId string = ''

@description('Optional. For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons.')
param setAzureWebJobsDashboard bool = contains(kind, 'functionapp') ? true : false

@description('Optional. The app settings-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.')
param appSettingsKeyValuePairs object = {}

@description('Optional. The auth settings V2 configuration.')
param authSettingV2Configuration object = {}

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. Configuration for deployment slots for an app.')
param slots array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'AppServiceHTTPLogs'
  'AppServiceConsoleLogs'
  'AppServiceAppLogs'
  'AppServiceAuditLogs'
  'AppServiceIPSecAuditLogs'
  'AppServicePlatformLogs'
  'FunctionAppLogs'
])
param diagnosticLogCategoriesToEnable array = kind == 'functionapp' ? [
  'FunctionAppLogs'
] : [
  'AppServiceHTTPLogs'
  'AppServiceConsoleLogs'
  'AppServiceAppLogs'
  'AppServiceAuditLogs'
  'AppServiceIPSecAuditLogs'
  'AppServicePlatformLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

@description('Optional. To enable client certificate authentication (TLS mutual authentication).')
param clientCertEnabled bool = false

@description('Optional. Client certificate authentication comma-separated exclusion paths.')
param clientCertExclusionPaths string = ''

@description('Optional. This composes with ClientCertEnabled setting.</p>- ClientCertEnabled: false means ClientCert is ignored.</p>- ClientCertEnabled: true and ClientCertMode: Required means ClientCert is required.</p>- ClientCertEnabled: true and ClientCertMode: Optional means ClientCert is optional or accepted.')
@allowed([
  'Optional'
  'OptionalInteractiveUser'
  'Required'
])
param clientCertMode string = 'Optional'

@description('Optional. If specified during app creation, the app is cloned from a source app.')
param cloningInfo object = {}

@description('Optional. Size of the function container.')
param containerSize int = -1

@description('Optional. Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification.')
param customDomainVerificationId string = ''

@description('Optional. Maximum allowed daily memory-time quota (applicable on dynamic apps only).')
param dailyMemoryTimeQuota int = -1

@description('Optional. Setting this value to false disables the app (takes the app offline).')
param enabled bool = true

@description('Optional. Hostname SSL states are used to manage the SSL bindings for app\'s hostnames.')
param hostNameSslStates array = []

@description('Optional. Hyper-V sandbox.')
param hyperV bool = false

@description('Optional. Site redundancy mode.')
@allowed([
  'ActiveActive'
  'Failover'
  'GeoRedundant'
  'Manual'
  'None'
])
param redundancyMode string = 'None'

@description('Optional. The site publishing credential policy names which are associated with the sites.')
param basicPublishingCredentialsPolicies array = []

@description('Optional. Names of hybrid connection relays to connect app with.')
param hybridConnectionRelays array = []

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs' && item != ''): {
  category: category
  enabled: true
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
  }
] : contains(diagnosticLogCategoriesToEnable, '') ? [] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
}]

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  'App Compliance Automation Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0f37683f-2463-46b6-9ce7-9b788b988ba2')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Logic App Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '87a39d53-fc1b-424a-814c-f7e04687dc9e')
  'Logic App Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '515c2055-d9d4-4321-b1b9-bd0c9a0f79fe')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Microsoft Sentinel Automation Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f4c81013-99ee-4d62-a7ee-b3f1f648599a')
  'Microsoft Sentinel Playbook Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '51d6186e-6489-4900-b93f-92e23144cca5')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Web Plan Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2cc479cb-7b4d-49a8-b449-8c00fd0f0a4b')
  'Website Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'de139f84-1756-47ae-9be6-808fbbe84772')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource app 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  kind: kind
  tags: tags
  identity: identity
  properties: {
    serverFarmId: serverFarmResourceId
    clientAffinityEnabled: clientAffinityEnabled
    httpsOnly: httpsOnly
    hostingEnvironmentProfile: !empty(appServiceEnvironmentResourceId) ? {
      id: appServiceEnvironmentResourceId
    } : null
    storageAccountRequired: storageAccountRequired
    keyVaultReferenceIdentity: !empty(keyVaultAccessIdentityResourceId) ? keyVaultAccessIdentityResourceId : null
    virtualNetworkSubnetId: !empty(virtualNetworkSubnetId) ? virtualNetworkSubnetId : any(null)
    siteConfig: siteConfig
    clientCertEnabled: clientCertEnabled
    clientCertExclusionPaths: !empty(clientCertExclusionPaths) ? clientCertExclusionPaths : null
    clientCertMode: clientCertMode
    cloningInfo: !empty(cloningInfo) ? cloningInfo : null
    containerSize: containerSize != -1 ? containerSize : null
    customDomainVerificationId: !empty(customDomainVerificationId) ? customDomainVerificationId : null
    dailyMemoryTimeQuota: dailyMemoryTimeQuota != -1 ? dailyMemoryTimeQuota : null
    enabled: enabled
    hostNameSslStates: hostNameSslStates
    hyperV: hyperV
    redundancyMode: redundancyMode
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) ? 'Disabled' : 'Enabled')
    vnetContentShareEnabled: vnetContentShareEnabled
    vnetImagePullEnabled: vnetImagePullEnabled
    vnetRouteAllEnabled: vnetRouteAllEnabled
    scmSiteAlsoStopped: scmSiteAlsoStopped
  }
}

module app_appsettings 'config--appsettings/main.bicep' = if (!empty(appSettingsKeyValuePairs)) {
  name: '${uniqueString(deployment().name, location)}-Site-Config-AppSettings'
  params: {
    appName: app.name
    kind: kind
    storageAccountResourceId: storageAccountResourceId
    appInsightResourceId: appInsightResourceId
    setAzureWebJobsDashboard: setAzureWebJobsDashboard
    appSettingsKeyValuePairs: appSettingsKeyValuePairs
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module app_authsettingsv2 'config--authsettingsv2/main.bicep' = if (!empty(authSettingV2Configuration)) {
  name: '${uniqueString(deployment().name, location)}-Site-Config-AuthSettingsV2'
  params: {
    appName: app.name
    kind: kind
    authSettingV2Configuration: authSettingV2Configuration
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

@batchSize(1)
module app_slots 'slot/main.bicep' = [for (slot, index) in slots: {
  name: '${uniqueString(deployment().name, location)}-Slot-${slot.name}'
  params: {
    name: slot.name
    appName: app.name
    location: location
    kind: kind
    serverFarmResourceId: serverFarmResourceId
    httpsOnly: contains(slot, 'httpsOnly') ? slot.httpsOnly : httpsOnly
    appServiceEnvironmentResourceId: !empty(appServiceEnvironmentResourceId) ? appServiceEnvironmentResourceId : ''
    clientAffinityEnabled: contains(slot, 'clientAffinityEnabled') ? slot.clientAffinityEnabled : clientAffinityEnabled
    systemAssignedIdentity: contains(slot, 'systemAssignedIdentity') ? slot.systemAssignedIdentity : systemAssignedIdentity
    userAssignedIdentities: contains(slot, 'userAssignedIdentities') ? slot.userAssignedIdentities : userAssignedIdentities
    keyVaultAccessIdentityResourceId: contains(slot, 'keyVaultAccessIdentityResourceId') ? slot.keyVaultAccessIdentityResourceId : keyVaultAccessIdentityResourceId
    storageAccountRequired: contains(slot, 'storageAccountRequired') ? slot.storageAccountRequired : storageAccountRequired
    virtualNetworkSubnetId: contains(slot, 'virtualNetworkSubnetId') ? slot.virtualNetworkSubnetId : virtualNetworkSubnetId
    siteConfig: contains(slot, 'siteConfig') ? slot.siteConfig : siteConfig
    storageAccountResourceId: contains(slot, 'storageAccountResourceId') ? slot.storageAccountResourceId : storageAccountResourceId
    appInsightResourceId: contains(slot, 'appInsightResourceId') ? slot.appInsightResourceId : appInsightResourceId
    setAzureWebJobsDashboard: contains(slot, 'setAzureWebJobsDashboard') ? slot.setAzureWebJobsDashboard : setAzureWebJobsDashboard
    authSettingV2Configuration: contains(slot, 'authSettingV2Configuration') ? slot.authSettingV2Configuration : authSettingV2Configuration
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    diagnosticStorageAccountId: contains(slot, 'diagnosticStorageAccountId') ? slot.diagnosticStorageAccountId : diagnosticStorageAccountId
    diagnosticWorkspaceId: contains(slot, 'diagnosticWorkspaceId') ? slot.diagnosticWorkspaceId : diagnosticWorkspaceId
    diagnosticEventHubAuthorizationRuleId: contains(slot, 'diagnosticEventHubAuthorizationRuleId') ? slot.diagnosticEventHubAuthorizationRuleId : diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: contains(slot, 'diagnosticEventHubName') ? slot.diagnosticEventHubName : diagnosticEventHubName
    diagnosticLogCategoriesToEnable: contains(slot, 'diagnosticLogCategoriesToEnable') ? slot.diagnosticLogCategoriesToEnable : diagnosticLogCategoriesToEnable
    diagnosticMetricsToEnable: contains(slot, 'diagnosticMetricsToEnable') ? slot.diagnosticMetricsToEnable : diagnosticMetricsToEnable
    roleAssignments: contains(slot, 'roleAssignments') ? slot.roleAssignments : roleAssignments
    appSettingsKeyValuePairs: contains(slot, 'appSettingsKeyValuePairs') ? slot.appSettingsKeyValuePairs : appSettingsKeyValuePairs
    lock: contains(slot, 'lock') ? slot.lock : lock
    privateEndpoints: contains(slot, 'privateEndpoints') ? slot.privateEndpoints : privateEndpoints
    tags: tags
    clientCertEnabled: contains(slot, 'clientCertEnabled') ? slot.clientCertEnabled : false
    clientCertExclusionPaths: contains(slot, 'clientCertExclusionPaths') ? slot.clientCertExclusionPaths : ''
    clientCertMode: contains(slot, 'clientCertMode') ? slot.clientCertMode : 'Optional'
    cloningInfo: contains(slot, 'cloningInfo') ? slot.cloningInfo : {}
    containerSize: contains(slot, 'containerSize') ? slot.containerSize : -1
    customDomainVerificationId: contains(slot, 'customDomainVerificationId') ? slot.customDomainVerificationId : ''
    dailyMemoryTimeQuota: contains(slot, 'dailyMemoryTimeQuota') ? slot.dailyMemoryTimeQuota : -1
    enabled: contains(slot, 'enabled') ? slot.enabled : true
    hostNameSslStates: contains(slot, 'hostNameSslStates') ? slot.hostNameSslStates : []
    hyperV: contains(slot, 'hyperV') ? slot.hyperV : false
    publicNetworkAccess: contains(slot, 'publicNetworkAccess') ? slot.publicNetworkAccess : ''
    redundancyMode: contains(slot, 'redundancyMode') ? slot.redundancyMode : 'None'
    vnetContentShareEnabled: contains(slot, 'vnetContentShareEnabled') ? slot.vnetContentShareEnabled : false
    vnetImagePullEnabled: contains(slot, 'vnetImagePullEnabled') ? slot.vnetImagePullEnabled : false
    vnetRouteAllEnabled: contains(slot, 'vnetRouteAllEnabled') ? slot.vnetRouteAllEnabled : false
    hybridConnectionRelays: contains(slot, 'hybridConnectionRelays') ? slot.hybridConnectionRelays : []
  }
}]

module app_basicPublishingCredentialsPolicies 'basic-publishing-credentials-policy/main.bicep' = [for (basicPublishingCredentialsPolicy, index) in basicPublishingCredentialsPolicies: {
  name: '${uniqueString(deployment().name, location)}-Site-Publis-Cred-${index}'
  params: {
    webAppName: app.name
    name: basicPublishingCredentialsPolicy.name
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module app_hybridConnectionRelays 'hybrid-connection-namespace/relay/main.bicep' = [for (hybridConnectionRelay, index) in hybridConnectionRelays: {
  name: '${uniqueString(deployment().name, location)}-HybridConnectionRelay-${index}'
  params: {
    hybridConnectionResourceId: hybridConnectionRelay.resourceId
    appName: app.name
    sendKeyName: contains(hybridConnectionRelay, 'sendKeyName') ? hybridConnectionRelay.sendKeyName : null
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource app_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: app
}

resource app_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: app
}

resource app_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(app.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: app
}]

module app_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Site-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(app.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: app.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: contains(privateEndpoint, 'location') ? privateEndpoint.location : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: contains(privateEndpoint, 'privateDnsZoneGroupName') ? privateEndpoint.privateDnsZoneGroupName : 'default'
    privateDnsZoneResourceIds: contains(privateEndpoint, 'privateDnsZoneResourceIds') ? privateEndpoint.privateDnsZoneResourceIds : []
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroupResourceIds: contains(privateEndpoint, 'applicationSecurityGroupResourceIds') ? privateEndpoint.applicationSecurityGroupResourceIds : []
    customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  }
}]

@description('The name of the site.')
output name string = app.name

@description('The resource ID of the site.')
output resourceId string = app.id

@description('The list of the slots.')
output slots array = [for (slot, index) in slots: app_slots[index].name]

@description('The list of the slot resource ids.')
output slotResourceIds array = [for (slot, index) in slots: app_slots[index].outputs.resourceId]

@description('The resource group the site was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(app.identity, 'principalId') ? app.identity.principalId : ''

@description('The principal ID of the system assigned identity of slots.')
output slotSystemAssignedPrincipalIds array = [for (slot, index) in slots: app_slots[index].outputs.systemAssignedPrincipalId]

@description('The location the resource was deployed into.')
output location string = app.location

@description('Default hostname of the app.')
output defaultHostname string = app.properties.defaultHostName

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device' | null)?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

metadata name = 'Static Web Apps'
metadata description = 'This module deploys a Static Web App.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the static site.')
@minLength(1)
@maxLength(40)
param name string

@allowed([
  'Free'
  'Standard'
])
@description('Optional. Type of static site to deploy.')
param sku string = 'Free'

@description('Optional. False if config file is locked for this static web app; otherwise, true.')
param allowConfigFileUpdates bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. State indicating whether staging environments are allowed or not allowed for a static web app.')
param stagingEnvironmentPolicy string = 'Enabled'

@allowed([
  'Disabled'
  'Disabling'
  'Enabled'
  'Enabling'
])
@description('Optional. State indicating the status of the enterprise grade CDN serving traffic to the static web app.')
param enterpriseGradeCdnStatus string = 'Disabled'

@description('Optional. Build properties for the static site.')
param buildProperties object = {}

@description('Optional. Template Options for the static site.')
param templateProperties object = {}

@description('Optional. The provider that submitted the last deployment to the primary environment of the static site.')
param provider string = 'None'

@secure()
@description('Optional. The Personal Access Token for accessing the GitHub repository.')
param repositoryToken string = ''

@description('Optional. The name of the GitHub repository.')
param repositoryUrl string = ''

@description('Optional. The branch name of the GitHub repository.')
param branch string = ''

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the \'sku\' to be \'Standard\'.')
param privateEndpoints array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Object with "resourceId" and "location" of the a user defined function app.')
param linkedBackend object = {}

@description('Optional. Static site app settings.')
param appSettings object = {}

@description('Optional. Function app settings.')
param functionAppSettings object = {}

@description('Optional. The custom domains associated with this static site. The deployment will fail as long as the validation records are not present.')
param customDomains array = []

var enableReferencedModulesTelemetry = false

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var builtInRoleNames = {
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

resource staticSite 'Microsoft.Web/staticSites@2021-03-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: sku
    tier: sku
  }
  properties: {
    allowConfigFileUpdates: allowConfigFileUpdates
    stagingEnvironmentPolicy: stagingEnvironmentPolicy
    enterpriseGradeCdnStatus: enterpriseGradeCdnStatus
    provider: !empty(provider) ? provider : 'None'
    branch: !empty(branch) ? branch : null
    buildProperties: !empty(buildProperties) ? buildProperties : null
    repositoryToken: !empty(repositoryToken) ? repositoryToken : null
    repositoryUrl: !empty(repositoryUrl) ? repositoryUrl : null
    templateProperties: !empty(templateProperties) ? templateProperties : null
  }
}

module staticSite_linkedBackend 'linked-backend/main.bicep' = if (!empty(linkedBackend)) {
  name: '${uniqueString(deployment().name, location)}-StaticSite-UserDefinedFunction'
  params: {
    staticSiteName: staticSite.name
    backendResourceId: linkedBackend.resourceId
    region: contains(linkedBackend, 'location') ? linkedBackend.location : location
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module staticSite_appSettings 'config/main.bicep' = if (!empty(appSettings)) {
  name: '${uniqueString(deployment().name, location)}-StaticSite-appSettings'
  params: {
    kind: 'appsettings'
    staticSiteName: staticSite.name
    properties: appSettings
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module staticSite_functionAppSettings 'config/main.bicep' = if (!empty(functionAppSettings)) {
  name: '${uniqueString(deployment().name, location)}-StaticSite-functionAppSettings'
  params: {
    kind: 'functionappsettings'
    staticSiteName: staticSite.name
    properties: functionAppSettings
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module staticSite_customDomains 'custom-domain/main.bicep' = [for (customDomain, index) in customDomains: {
  name: '${uniqueString(deployment().name, location)}-StaticSite-customDomains-${index}'
  params: {
    name: customDomain
    staticSiteName: staticSite.name
    validationMethod: indexOf(customDomain, '.') == lastIndexOf(customDomain, '.') ? 'dns-txt-token' : 'cname-delegation'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource staticSite_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: staticSite
}

resource staticSite_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(staticSite.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: staticSite
}]

module staticSite_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-StaticSite-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(staticSite.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: staticSite.id
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

@description('The name of the static site.')
output name string = staticSite.name

@description('The resource ID of the static site.')
output resourceId string = staticSite.id

@description('The resource group the static site was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(staticSite.identity, 'principalId') ? staticSite.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = staticSite.location

@description('The default autogenerated hostname for the static site.')
output defaultHostname string = staticSite.properties.defaultHostname

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

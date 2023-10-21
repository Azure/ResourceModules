metadata name = 'CDN Profiles'
metadata description = 'This module deploys a CDN Profile.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the CDN profile.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@allowed([
  'Custom_Verizon'
  'Premium_AzureFrontDoor'
  'Premium_Verizon'
  'StandardPlus_955BandWidth_ChinaCdn'
  'StandardPlus_AvgBandWidth_ChinaCdn'
  'StandardPlus_ChinaCdn'
  'Standard_955BandWidth_ChinaCdn'
  'Standard_Akamai'
  'Standard_AvgBandWidth_ChinaCdn'
  'Standard_AzureFrontDoor'
  'Standard_ChinaCdn'
  'Standard_Microsoft'
  'Standard_Verizon'
])
@description('Required. The pricing tier (defines a CDN provider, feature list and rate) of the CDN profile.')
param sku string

@description('Optional. Send and receive timeout on forwarding request to the origin.')
param originResponseTimeoutSeconds int = 60

@description('Optional. Name of the endpoint under the profile which is unique globally.')
param endpointName string = ''

@description('Optional. Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details).')
param endpointProperties object = {}

@description('Optional. Array of secret objects.')
param secrets array = []

@description('Optional. Array of custom domain objects.')
param customDomains array = []

@description('Conditional. Array of origin group objects. Required if the afdEndpoints is specified.')
param origionGroups array = []

@description('Optional. Array of rule set objects.')
param ruleSets array = []

@description('Optional. Array of AFD endpoint objects.')
param afdEndpoints array = []

@description('Optional. Endpoint tags.')
param tags object = {}

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  'Azure Front Door Domain Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0ab34830-df19-4f8c-b84e-aa85b8afa6e8')
  'Azure Front Door Domain Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0f99d363-226e-4dca-9920-b807cf8e1a5f')
  'Azure Front Door Secret Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3f2eb865-5811-4578-b90a-6fc6fa0df8e5')
  'Azure Front Door Secret Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0db238c4-885e-4c4f-a933-aa2cef684fca')
  'CDN Endpoint Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '426e0c7f-0c7e-4658-b36f-ff54d6c29b45')
  'CDN Endpoint Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '871e35f6-b5c1-49cc-a043-bde969a0f2cd')
  'CDN Profile Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ec156ff8-a8d1-4d15-830c-5b80698ca432')
  'CDN Profile Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8f96442b-4075-438f-813d-ad51ab4019af')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

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

resource profile 'Microsoft.Cdn/profiles@2023-05-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    originResponseTimeoutSeconds: originResponseTimeoutSeconds
  }
  tags: tags
}

resource profile_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: profile
}

resource profile_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(profile.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: profile
}]

module profile_endpoint 'endpoint/main.bicep' = if (!empty(endpointProperties)) {
  name: '${uniqueString(deployment().name, location)}-Profile-Endpoint'
  params: {
    name: !empty(endpointName) ? endpointName : '${profile.name}-endpoint'
    properties: endpointProperties
    location: location
    profileName: profile.name
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module profile_secret 'secret/main.bicep' = [for (secret, index) in secrets: {
  name: '${uniqueString(deployment().name)}-Profile-Secret-${index}'
  params: {
    name: secret.name
    profileName: profile.name
    type: secret.type
    secretSourceResourceId: secret.secretSourceResourceId
    subjectAlternativeNames: contains(secret, 'subjectAlternativeNames') ? secret.subjectAlternativeNames : []
    useLatestVersion: contains(secret, 'useLatestVersion') ? secret.useLatestVersion : false
    secretVersion: secret.secretVersion
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module profile_custom_domain 'customdomain/main.bicep' = [for (customDomain, index) in customDomains: {
  name: '${uniqueString(deployment().name)}-CustomDomain-${index}'
  dependsOn: [
    profile_secret
  ]
  params: {
    name: customDomain.name
    profileName: profile.name
    hostName: customDomain.hostName
    azureDnsZoneResourceId: contains(customDomain, 'azureDnsZoneResourceId') ? customDomain.azureDnsZoneResourceId : ''
    extendedProperties: contains(customDomain, 'extendedProperties') ? customDomain.extendedProperties : {}
    certificateType: customDomain.certificateType
    minimumTlsVersion: contains(customDomain, 'minimumTlsVersion') ? customDomain.minimumTlsVersion : 'TLS12'
    preValidatedCustomDomainResourceId: contains(customDomain, 'preValidatedCustomDomainResourceId') ? customDomain.preValidatedCustomDomainResourceId : ''
    secretName: contains(customDomain, 'secretName') ? customDomain.secretName : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module profile_origionGroup 'origingroup/main.bicep' = [for (origingroup, index) in origionGroups: {
  name: '${uniqueString(deployment().name)}-Profile-OrigionGroup-${index}'
  params: {
    name: origingroup.name
    profileName: profile.name
    healthProbeSettings: contains(origingroup, 'healthProbeSettings') ? origingroup.healthProbeSettings : {}
    loadBalancingSettings: origingroup.loadBalancingSettings
    sessionAffinityState: contains(origingroup, 'sessionAffinityState') ? origingroup.sessionAffinityState : 'Disabled'
    trafficRestorationTimeToHealedOrNewEndpointsInMinutes: contains(origingroup, 'trafficRestorationTimeToHealedOrNewEndpointsInMinutes') ? origingroup.trafficRestorationTimeToHealedOrNewEndpointsInMinutes : 10
    origins: origingroup.origins
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module profile_ruleSet 'ruleset/main.bicep' = [for (ruleSet, index) in ruleSets: {
  name: '${uniqueString(deployment().name)}-Profile-RuleSet-${index}'
  params: {
    name: ruleSet.name
    profileName: profile.name
    rules: ruleSet.rules
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module profile_afdEndpoint 'afdEndpoint/main.bicep' = [for (afdEndpoint, index) in afdEndpoints: {
  name: '${uniqueString(deployment().name)}-Profile-AfdEndpoint-${index}'
  dependsOn: [
    profile_origionGroup
    profile_custom_domain
    profile_ruleSet
  ]
  params: {
    name: afdEndpoint.name
    location: location
    profileName: profile.name
    autoGeneratedDomainNameLabelScope: contains(afdEndpoint, 'autoGeneratedDomainNameLabelScope') ? afdEndpoint.autoGeneratedDomainNameLabelScope : 'TenantReuse'
    enabledState: contains(afdEndpoint, 'enabledState') ? afdEndpoint.enabledState : 'Enabled'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    routes: contains(afdEndpoint, 'routes') ? afdEndpoint.routes : []
    tags: contains(afdEndpoint, 'tags') ? afdEndpoint.tags : {}
  }
}]

@description('The name of the CDN profile.')
output name string = profile.name

@description('The resource ID of the CDN profile.')
output resourceId string = profile.id

@description('The resource group where the CDN profile is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The type of the CDN profile.')
output profileType string = profile.type

@description('The location the resource was deployed into.')
output location string = profile.location

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

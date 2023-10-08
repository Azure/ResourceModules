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

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

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

resource profile_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${profile.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: profile
}

module profile_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Profile-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: profile.id
  }
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

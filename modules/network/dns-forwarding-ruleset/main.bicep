metadata name = 'Dns Forwarding Rulesets'
metadata description = 'This template deploys an dns forwarding ruleset.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the DNS Forwarding Ruleset.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Required. The reference to the DNS resolver outbound endpoints that are used to route DNS queries matching the forwarding rules in the ruleset to the target DNS servers.')
param dnsResolverOutboundEndpointResourceIds array

@description('Optional. Array of forwarding rules.')
param forwardingRules array = []

@description('Optional. Array of virtual network links.')
param vNetLinks array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

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

resource dnsForwardingRuleset 'Microsoft.Network/dnsForwardingRulesets@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    dnsResolverOutboundEndpoints: [for dnsResolverOutboundEndpointResourceId in dnsResolverOutboundEndpointResourceIds: {
      id: dnsResolverOutboundEndpointResourceId
    }]
  }
}

module dnsForwardingRuleset_forwardingRule 'forwarding-rule/main.bicep' = [for (forwardingRule, index) in forwardingRules: {
  name: '${uniqueString(deployment().name, location)}-forwardingRule-${index}'
  params: {
    dnsForwardingRulesetName: dnsForwardingRuleset.name
    name: forwardingRule.name
    forwardingRuleState: forwardingRule.forwardingRuleState
    domainName: forwardingRule.domainName
    targetDnsServers: forwardingRule.targetDnsServers
  }
}]

module dnsForwardingRuleset_virtualNetworkLinks 'virtual-network-link/main.bicep' = [for (vnetId, index) in vNetLinks: {
  name: '${uniqueString(deployment().name, location)}-virtualNetworkLink-${index}'
  params: {
    dnsForwardingRulesetName: dnsForwardingRuleset.name
    virtualNetworkResourceId: !empty(vNetLinks) ? vnetId : null
  }
}]

resource dnsForwardingRulesets_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${dnsForwardingRuleset.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: dnsForwardingRuleset
}

module dnsForwardingRulesets_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-dnsResolver-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: dnsForwardingRuleset.id
  }
}]

@description('The resource group the DNS Forwarding Ruleset was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the DNS Forwarding Ruleset.')
output resourceId string = dnsForwardingRuleset.id

@description('The name of the DNS Forwarding Ruleset.')
output name string = dnsForwardingRuleset.name

@description('The location the resource was deployed into.')
output location string = dnsForwardingRuleset.location

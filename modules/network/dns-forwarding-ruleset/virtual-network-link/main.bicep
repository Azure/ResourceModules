metadata name = 'Dns Forwarding Rulesets Virtual Network Links'
metadata description = 'This template deploys Virtual Network Link in a Dns Forwarding Ruleset.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent DNS Fowarding Rule Set. Required if the template is used in a standalone deployment.')
param dnsForwardingRulesetName string

@description('Optional. The name of the virtual network link.')
param name string = '${last(split(virtualNetworkResourceId, '/'))}-vnetlink'

@description('Optional. The location of the PrivateDNSZone. Should be global.')
param location string = 'global'

@description('Required. Link to another virtual network resource ID.')
param virtualNetworkResourceId string

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

resource dnsForwardingRuleset 'Microsoft.Network/dnsForwardingRulesets@2022-07-01' existing = {
  name: dnsForwardingRulesetName
}

resource virtualNetworkLink 'Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks@2022-07-01' = {
  name: name
  parent: dnsForwardingRuleset
  properties: {
    virtualNetwork: {
      id: virtualNetworkResourceId
    }
  }
}

@description('The name of the deployed virtual network link.')
output name string = virtualNetworkLink.name

@description('The resource ID of the deployed virtual network link.')
output resourceId string = virtualNetworkLink.id

@description('The resource group of the deployed virtual network link.')
output resourceGroupName string = resourceGroup().name

@description('Required. Name of the Firewall Policy.')
param firewallPolicyName string

@description('Required. The name of the rule collection group to deploy')
param name string

@description('Required. Priority of the Firewall Policy Rule Collection Group resource.')
param priority int

@description('Optional. Group of Firewall Policy rule collections.')
param ruleCollections array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: firewallPolicyName
}

resource ruleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-05-01' = {
  name: name
  parent: firewallPolicy
  properties: {
    priority: priority
    ruleCollections: ruleCollections
  }
}

@description('The name of the deployed rule collection group')
output name string = ruleCollectionGroup.name

@description('The resource ID of the deployed rule collection group')
output resourceId string = ruleCollectionGroup.id

@description('The resource group of the deployed rule collection group')
output resourceGroupName string = resourceGroup().name

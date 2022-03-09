@description('Required. Name of the Firewall Policy.')
param firewallPolicyName string

@description('Required. The name of the rule group to deploy')
param name string

@description('Required. Priority of the Firewall Policy Rule Group resource.')
param priority int

@description('Optional. Group of Firewall rules.')
param rules array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: firewallPolicyName
}

resource ruleGroup 'Microsoft.Network/firewallPolicies/ruleGroups@2020-04-01' = {
  name: name
  parent: firewallPolicy
  properties: {
    priority: priority
    rules: rules
  }
}

@description('The name of the deployed rule group')
output name string = ruleGroup.name

@description('The resource ID of the deployed rule group')
output resourceId string = ruleGroup.id

@description('The resource group of the deployed rule group')
output resourceGroupName string = resourceGroup().name

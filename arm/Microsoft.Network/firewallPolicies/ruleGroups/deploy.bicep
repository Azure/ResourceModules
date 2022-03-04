@description('Required. Name of the Firewall Policy.')
param firewallPolicyName string

@description('Required. The name of the rule group to deploy')
param name string

@description('Required. Priority of the Firewall Policy Rule Group resource.')
param priority int

@description('Optional. Group of Firewall rules.')
param rules array = []

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

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

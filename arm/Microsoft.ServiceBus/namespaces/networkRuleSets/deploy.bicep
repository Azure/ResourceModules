@description('Conditional. The name of the parent Service Bus Namespace for the Service Bus Network Rule Set. Required if the template is used in a standalone deployment.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Required. The default is the only valid ruleset.')
param name string = 'default'

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. Configure networking options for Premium SKU Service Bus, ipRules and virtualNetworkRules are not required when using dedicated modules.')
param networkRuleSet object = {}

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

resource namespace 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' existing = {
  name: namespaceName
}

resource serviceBusNamespace_networkRuleSet 'Microsoft.ServiceBus/namespaces/networkRuleSets@2021-11-01' = {
  name: name
  parent: namespace
  properties: {
    defaultAction: networkRuleSet.defaultAction
    publicNetworkAccess: networkRuleSet.publicNetworkAccess
    trustedServiceAccessEnabled: networkRuleSet.trustedServiceAccessEnabled
    ipRules: networkRuleSet.ipRules
    virtualNetworkRules: networkRuleSet.virtualNetworkRules
  }
}

@description('The name of the Network ACL Deployment.')
output name string = networkRuleSet.name

@description('The Resource ID of the virtual network rule.')
output resourceId string = networkRuleSet.id

@description('The name of the Resource Group the virtual network rule was created in.')
output resourceGroupName string = resourceGroup().name

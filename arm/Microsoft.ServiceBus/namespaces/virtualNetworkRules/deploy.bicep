@description('Conditional. The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Optional. The name of the virtual network rule.')
param name string = '${namespaceName}-vnr'

@description('Required. Resource ID of Virtual Network Subnet.')
param virtualNetworkSubnetId string

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

resource namespace 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' existing = {
  name: namespaceName
}

resource virtualNetworkRule 'Microsoft.ServiceBus/namespaces/virtualNetworkRules@2018-01-01-preview' = {
  name: name
  parent: namespace
  properties: {
    virtualNetworkSubnetId: virtualNetworkSubnetId
  }
}

@description('The name of the virtual network rule.')
output name string = virtualNetworkRule.name

@description('The Resource ID of the virtual network rule.')
output resourceId string = virtualNetworkRule.id

@description('The name of the Resource Group the virtual network rule was created in.')
output resourceGroupName string = resourceGroup().name

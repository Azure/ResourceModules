@description('Required. Name of the parent Service Bus Namespace for the Service Bus Queue.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Optional. The name of the virtual network rule')
param name string = '${namespaceName}-vnr'

@description('Required. Resource ID of Virtual Network Subnet')
param virtualNetworkSubnetId string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource virtualNetworkRule 'Microsoft.ServiceBus/namespaces/virtualNetworkRules@2018-01-01-preview' = {
  name: '${namespaceName}/${name}'
  properties: {
    virtualNetworkSubnetId: virtualNetworkSubnetId
  }
}

@description('The name of the virtual network rule.')
output virtualNetworkRuleName string = virtualNetworkRule.name

@description('The Resource Id of the virtual network rule.')
output virtualNetworkRuleResourceId string = virtualNetworkRule.id

@description('The name of the Resource Group the virtual network rule was created in.')
output virtualNetworkRuleResourceGroup string = resourceGroup().name

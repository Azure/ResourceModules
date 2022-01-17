@description('Required. The name of the parent load balancer')
param loadBalancerName string

@description('Required. The name of the backend address pool')
param name string

@description('Optional. An array of backend addresses.')
param loadBalancerBackendAddresses array = []

@description('Optional. An array of gateway load balancer tunnel interfaces.')
param tunnelInterfaces array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

resource pid_cuaId 'Microsoft.Resources/deployments@2021-04-01' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-02-01' existing = {
  name: loadBalancerName
}

resource backendAddressPool 'Microsoft.Network/loadBalancers/backendAddressPools@2021-05-01' = {
  name: name
  properties: {
    loadBalancerBackendAddresses: loadBalancerBackendAddresses
    tunnelInterfaces: tunnelInterfaces
  }
  parent: loadBalancer
}

@description('The name of the backend address pool')
output inboundNatRuleName string = backendAddressPool.name

@description('The resource ID of the backend address pool')
output inboundNatRuleResourceId string = backendAddressPool.id

@description('The resource group the backend address pool was deployed into')
output inboundNatRuleResourceGroupName string = resourceGroup().name

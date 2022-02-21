@description('Required. The name of the NAT rule.')
param name string

@description('Required. The name of the VPN gateway this NAT rule is associated with.')
param vpnGatewayName string

@description('Optional. The private IP address external mapping for NAT.')
param externalMappings array = []

@description('Optional. The private IP address external mapping for NAT.')
param internalMappings array = []

@description('Optional. The IP Configuration ID this NAT rule applies to.')
param ipConfigurationId string

@description('Optional. The type of NAT rule for VPN NAT.')
@allowed([
  'EgressSnat'
  'IngressSnat'
])
param mode string

@description('Optional. The type of NAT rule for VPN NAT.')
@allowed([
  'Dynamic'
  'Static'
])
param type string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource vpnGateway 'Microsoft.Network/vpnGateways@2021-03-01' existing = {
  name: vpnGatewayName
}

resource natRule 'Microsoft.Network/vpnGateways/natRules@2021-05-01' = {
  name: name
  parent: vpnGateway
  properties: {
    externalMappings: externalMappings
    internalMappings: internalMappings
    ipConfigurationId: ipConfigurationId
    mode: mode
    type: type
  }
}

@description('The name of the NAT rule')
output name string = natRule.name

@description('The resource ID of the NAT rule')
output resourceId string = natRule.id

@description('The name of the resource group the NAT rule was deployed into')
output resourceGroupName string = resourceGroup().name

@description('Optional. The Name of the subnet resource.')
param name string

@description('Required. The name of the parent virtual network')
param virtualNetworkName string

@description('Required. The address prefix for the subnet.')
param addressPrefix string

@description('Optional. The network security group to assign to the subnet')
param networkSecurityGroupName string = ''

@description('Optional. Resource Group where NSGs are deployed, if different than VNET Resource Group.')
@minLength(1)
param networkSecurityGroupNameResourceGroupName string = resourceGroup().name

@description('Optional. The route table to assign to the subnet')
param routeTableName string = ''

@description('Optional. The service endpoints to enable on the subnet')
param serviceEndpoints array = []

@description('Optional. The delegations to enable on the subnet')
param delegations array = []

@description('Optional. The name of the NAT Gateway to use for the subnet')
param natGatewayName string = ''

@description('Optional. enable or disable apply network policies on private end point in the subnet.')
@allowed([
  'Disabled'
  'Enabled'
  ''
])
param privateEndpointNetworkPolicies string = ''

@description('Optional. enable or disable apply network policies on private link service in the subnet.')
@allowed([
  'Disabled'
  'Enabled'
  ''
])
param privateLinkServiceNetworkPolicies string = ''

@description('Optional. List of address prefixes for the subnet.')
param addressPrefixes array = []

@description('Optional. Application gateway IP configurations of virtual network resource.')
param applicationGatewayIpConfigurations array = []

@description('Optional. Array of IpAllocation which reference this subnet')
param ipAllocations array = []

@description('Optional. An array of service endpoint policies.')
param serviceEndpointPolicies array = []

var formattedServiceEndpoints = [for serviceEndpoint in serviceEndpoints: {
  service: serviceEndpoint
}]

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: virtualNetworkName
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' existing = if (!empty(networkSecurityGroupName)) {
  name: networkSecurityGroupName
  scope: resourceGroup(networkSecurityGroupNameResourceGroupName)
}

resource routeTable 'Microsoft.Network/routeTables@2021-05-01' existing = if (!empty(routeTableName)) {
  name: routeTableName
}

resource natGateway 'Microsoft.Network/natGateways@2021-05-01' existing = if (!empty(natGatewayName)) {
  name: natGatewayName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: name
  parent: virtualNetwork
  properties: {
    addressPrefix: addressPrefix
    networkSecurityGroup: !empty(networkSecurityGroupName) ? {
      id: networkSecurityGroup.id
    } : null
    routeTable: !empty(routeTableName) ? {
      id: routeTable.id
    } : null
    natGateway: !empty(natGatewayName) ? {
      id: natGateway.id
    } : null
    serviceEndpoints: !empty(formattedServiceEndpoints) ? formattedServiceEndpoints : []
    delegations: delegations
    privateEndpointNetworkPolicies: !empty(privateEndpointNetworkPolicies) ? any(privateEndpointNetworkPolicies) : null
    privateLinkServiceNetworkPolicies: !empty(privateLinkServiceNetworkPolicies) ? any(privateLinkServiceNetworkPolicies) : null
    addressPrefixes: addressPrefixes
    applicationGatewayIpConfigurations: applicationGatewayIpConfigurations
    ipAllocations: ipAllocations
    serviceEndpointPolicies: serviceEndpointPolicies
  }
}

@description('The resource group the virtual network peering was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The name of the virtual network peering')
output name string = subnet.name

@description('The resource ID of the virtual network peering')
output resourceId string = subnet.id

@description('The address prefix for the subnet')
output subnetAddressPrefix string = subnet.properties.addressPrefix

@description('List of address prefixes for the subnet')
output subnetAddressPrefixes array = !empty(addressPrefixes) ? subnet.properties.addressPrefixes : []

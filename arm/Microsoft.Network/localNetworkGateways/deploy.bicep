@description('Required. Name of the Local Network Gateway')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. List of the local (on-premises) IP address ranges')
param localAddressPrefixes array

@description('Required. Public IP of the local gateway')
param localGatewayPublicIpAddress string

@description('Optional. The BGP speaker\'s ASN. Not providing this value will automatically disable BGP on this Local Network Gateway resource.')
param localAsn string = ''

@description('Optional. The BGP peering address and BGP identifier of this BGP speaker. Not providing this value will automatically disable BGP on this Local Network Gateway resource.')
param localBgpPeeringAddress string = ''

@description('Optional. The weight added to routes learned from this BGP speaker. This will only take effect if both the localAsn and the localBgpPeeringAddress values are provided.')
param localPeerWeight string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. FQDN of local network gateway.')
param fqdn string = ''

var bgpSettings = {
  asn: localAsn
  bgpPeeringAddress: localBgpPeeringAddress
  peerWeight: !empty(localPeerWeight) ? localPeerWeight : '0'
}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2021-02-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: localAddressPrefixes
    }
    fqdn: !empty(fqdn) ? fqdn : null
    gatewayIpAddress: localGatewayPublicIpAddress
    bgpSettings: !empty(localAsn) && !empty(localBgpPeeringAddress) ? bgpSettings : null
  }
}

resource localNetworkGateway_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${localNetworkGateway.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: localNetworkGateway
}

module localNetworkGateway_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-LocalNetworkGateway-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: localNetworkGateway.id
  }
}]

@description('The resource ID of the local network gateway')
output localNetworkGatewayResourceId string = localNetworkGateway.id

@description('The resource group the local network gateway was deployed into')
output localNetworkGatewayResourceGroup string = resourceGroup().name

@description('The name of the local network gateway')
output localNetworkGatewayName string = localNetworkGateway.name

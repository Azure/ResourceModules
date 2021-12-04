@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Required. Name of the Virtual Wan.')
param name string

@description('Optional. Sku of the Virtual Wan.')
@allowed([
  'Standard'
  'Basic'
])
param virtualWanSku string = 'Standard'

@description('Optional. Name of the Virtual Hub. A virtual hub is created inside a virtual wan.')
param virtualHubName string = 'SampleVirtualHub'

@description('Optional. Name of the Vpn Gateway. A vpn gateway is created inside a virtual hub.')
param vpnGatewayName string = 'SampleVpnGateway'

@description('Optional. Name of the vpnsite. A vpnsite represents the on-premise vpn device. A public ip address is mandatory for a vpn site creation.')
param vpnSiteName string = 'SampleVpnSite'

@description('Optional. Name of the vpnconnection. A vpn connection is established between a vpnsite and a vpn gateway.')
param connectionName string = 'SampleVpnsiteVpnGwConnection'

@description('Optional. A list of static routes corresponding to the vpn site. These are configured on the vpn gateway.')
param vpnsiteAddressspaceList array = []

@description('Required. he public IP address of a vpn site.')
param vpnsitePublicIPAddress string

@description('Required. The bgp asn number of a vpnsite.')
param vpnsiteBgpAsn int

@description('Required. The bgp peer IP address of a vpnsite.')
param vpnsiteBgpPeeringAddress string

@description('Optional. The hub address prefix. This address prefix will be used as the address prefix for the hub vnet')
param addressPrefix string = '192.168.0.0/24'

@description('Optional. his needs to be set to true if BGP needs to enabled on the vpn connection.')
@allowed([
  'true'
  'false'
])
param enableBgp string = 'false'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource virtualWan 'Microsoft.Network/virtualWans@2021-03-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    type: virtualWanSku
  }
}

resource virtualWan_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${virtualWan.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualWan
}

resource virtualHub 'Microsoft.Network/virtualHubs@2021-03-01' = {
  name: virtualHubName
  location: location
  properties: {
    addressPrefix: addressPrefix
    virtualWan: {
      id: virtualWan.id
    }
  }
}

resource virtualHub_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${virtualHub.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualHub
}

resource vpnSite 'Microsoft.Network/vpnSites@2021-03-01' = {
  name: vpnSiteName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vpnsiteAddressspaceList
    }
    bgpProperties: {
      asn: vpnsiteBgpAsn
      bgpPeeringAddress: vpnsiteBgpPeeringAddress
      peerWeight: 0
    }
    deviceProperties: {
      linkSpeedInMbps: 0
    }
    ipAddress: vpnsitePublicIPAddress
    virtualWan: {
      id: virtualWan.id
    }
  }
}

resource vpnSite_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${vpnSite.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: vpnSite
}

resource vpnGateway 'Microsoft.Network/vpnGateways@2021-03-01' = {
  name: vpnGatewayName
  location: location
  properties: {
    connections: [
      {
        name: connectionName
        properties: {
          connectionBandwidth: 10
          enableBgp: any(enableBgp)
          remoteVpnSite: {
            id: vpnSite.id
          }
        }
      }
    ]
    virtualHub: {
      id: virtualHub.id
    }
    bgpSettings: {
      asn: 65515
    }
  }
}

resource vpnGateway_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${vpnGateway.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: vpnGateway
}

module virtualWan_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-VWan-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: virtualWan.id
  }
}]

@description('The name of the virtual WAN')
output virtualWanName string = virtualWan.name

@description('The resource ID of the virtual WAN')
output virtualWanResourceId string = virtualWan.id

@description('The resource group the virtual WAN was deployed into')
output virtualWanResourceGroup string = resourceGroup().name

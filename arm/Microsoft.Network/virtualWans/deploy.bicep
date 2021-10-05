@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Required. Name of the Virtual Wan.')
param virtualWanName string

@description('Optional. Sku of the Virtual Wan.')
@allowed([
  'Standard'
  'Basic'
])
param wanSku string = 'Standard'

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

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Switch to lock storage from deletion.')
param lockForDeletion bool = false

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource virtualWan 'Microsoft.Network/virtualWans@2021-05-01' = {
  name: virtualWanName
  location: location
  tags: tags
  properties: {
    type: wanSku
  }
}

resource virtualWan_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${virtualWanName}-virtualWanDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: virtualWan
}

resource virtualHub 'Microsoft.Network/virtualHubs@2021-05-01' = {
  name: virtualHubName
  location: location
  properties: {
    addressPrefix: addressPrefix
    virtualWan: {
      id: virtualWan.id
    }
  }
}

resource virtualHub_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${virtualHubName}-virtualHubDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: virtualHub
}

resource vpnSite 'Microsoft.Network/vpnSites@2021-05-01' = {
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

resource vpnSite_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${vpnSiteName}-vpnSiteDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: vpnSite
}

resource vpnGateway 'Microsoft.Network/vpnGateways@2021-05-01' = {
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

resource vpnGateway_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${vpnGatewayName}-vpnGatewayDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: vpnGateway
}

module virtualWan_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: virtualWan.name
  }
}]

output virtualWanName string = virtualWan.name
output virtualWanNameResourceId string = virtualWan.id
output virtualWanNameResourceGroup string = resourceGroup().name

@description('Required. Private DNS zone name.')
param privateDnsZoneName string

@description('Optional. Array of custom objects describing vNet links of the DNS zone. Each object should contain properties \'vnetResourceId\' and \'registrationEnabled\'. The \'vnetResourceId\' is a resource Id of a vNet to link, \'registrationEnabled\' (bool) enables automatic DNS registration in the zone for the linked vNet.')
param vnetLinks array = []

@description('Optional. The location of the PrivateDNSZone. Should be global.')
param location string = 'global'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZoneName
  location: location
  tags: tags

  resource virtualNetworkLinks 'virtualNetworkLinks@2018-09-01' = [for vnetLink in vnetLinks: if (!empty(vnetLinks)) {
    name: '${(empty(vnetLinks) ? 'dummy' : last(split(vnetLink.vnetResourceId, '/')))}'
    location: location
    tags: tags
    properties: {
      registrationEnabled: vnetLink.registrationEnabled
      virtualNetwork: {
        id: vnetLink.vnetResourceId
      }
    }
  }]
}

resource privateDnsZone_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${privateDnsZone.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: privateDnsZone
}

module privateDnsZone_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: privateDnsZone.name
  }
}]

output privateDnsZoneResourceGroup string = resourceGroup().name
output privateDnsZoneName string = privateDnsZone.name
output privateDnsZoneResourceId string = privateDnsZone.id

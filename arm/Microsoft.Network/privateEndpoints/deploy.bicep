@description('Required. Name of the private endpoint resource to create.')
param privateEndpointName string

@description('Required. Resource ID of the subnet where the endpoint needs to be created.')
param targetSubnetId string

@description('Required. Resource ID of the resource that needs to be connected to the network.')
param serviceResourceId string

@description('Required. Subtype(s) of the connection to be created. The allowed values depend on the type serviceResourceId refers to.')
param groupId array

@description('Optional. Array of Private DNS zone groups configuration on the private endpoint.')
param privateDnsZoneGroups array = []

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_pid.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: privateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: serviceResourceId
          groupIds: groupId
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: targetSubnetId
    }
    customDnsConfigs: []
  }
}

module privateEndpoint_privateDnsZoneGroups 'privateDnsZoneGroups/deploy.bicep' = [for (privateDnsZoneGroup, index) in privateDnsZoneGroups: {
  name: '${deployment().name}-privateDnsZoneGroup-${index}'
  params: {
    privateDNSIds: privateDnsZoneGroup.privateDNSIds
    privateEndpointName: privateEndpoint.name
  }
}]

resource privateEndpoint_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${privateEndpoint.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: privateEndpoint
}

module privateEndpoint_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: privateEndpoint.name
  }
}]

@description('The resource group the private endpoint was deployed into')
output privateEndpointResourceGroup string = resourceGroup().name

@description('The resource ID of the private endpoint')
output privateEndpointResourceId string = privateEndpoint.id

@description('The name of the private endpoint')
output privateEndpointName string = privateEndpoint.name

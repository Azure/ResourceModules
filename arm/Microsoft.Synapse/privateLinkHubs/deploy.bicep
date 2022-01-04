@description('Required. The name of the Private Link Hub.')
param name string

@description('Required. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

resource synapsePrivateLinkHub 'Microsoft.Synapse/privateLinkHubs@2021-06-01' = {
  name: name
  location: location
  tags: tags
}

// Resource Lock
resource synapsePrivateLinkHub_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${synapsePrivateLinkHub.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: synapsePrivateLinkHub
}

// RBAC
module synapsePrivateLinkHub_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: synapsePrivateLinkHub.id
  }
}]

// Private Endpoints
module synapsePrivateLinkHub_privateEndpoints '.bicep/nested_privateEndpoint.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-PrivateEndpoint-${index}'
  params: {
    privateEndpointResourceId: synapsePrivateLinkHub.id
    privateEndpointVnetLocation: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    privateEndpointObj: privateEndpoint
    tags: tags
  }
}]

@description('The resource ID of the deployed Synapse Private Link Hub.')
output synapsePrivateLinkHubResourceId string = synapsePrivateLinkHub.id

@description('The name of the deployed Synapse Private Link Hub.')
output synapsePrivateLinkHubName string = synapsePrivateLinkHub.name

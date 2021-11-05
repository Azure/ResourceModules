@description('Required. Name of the Private Link Scope.')
@minLength(1)
param privateLinkScopeName string

@description('Optional. The location of the Private Link Scope. Should be global.')
param location string = 'global'

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Configuration Details for Azure Monitor Resources.')
param scopedResources array = []

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource privateLinkScope 'Microsoft.Insights/privateLinkScopes@2019-10-17-preview' = {
  name: privateLinkScopeName
  location: location
  tags: tags
  properties: {}

  resource privateLinkScope_scopedResources 'scopedresources@2019-10-17-preview' = [for (scopedResource, index) in scopedResources: {
    name: 'scoped-${last(split(scopedResource.linkedResourceId, '/'))}-${guid(uniqueString(privateLinkScope.name, scopedResource.linkedResourceId))}'
    properties: {
      linkedResourceId: scopedResource.linkedResourceId
    }
  }]
}

resource privateLinkScope_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${privateLinkScope.name}-${lock}-lock'
  scope: privateLinkScope
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
}

module privateLinkScope_privateEndpoints '.bicep/nested_privateEndpoint.bicep' = [for (endpoint, index) in privateEndpoints: if (!empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-Storage-PrivateEndpoints-${index}'
  params: {
    privateEndpointResourceId: privateLinkScope.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(endpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpointObj: endpoint
    tags: tags
  }
}]

module privateLinkScope_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: privateLinkScope.name
  }
}]

output privateLinkScopeName string = privateLinkScope.name
output privateLinkScopeResourceId string = privateLinkScope.id
output privateLinkScopeResourceGroup string = resourceGroup().name

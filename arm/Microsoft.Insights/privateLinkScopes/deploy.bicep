@description('Required. Name of the private link scope.')
@minLength(1)
param name string

@description('Optional. The location of the private link scope. Should be global.')
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

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource privateLinkScope 'Microsoft.Insights/privateLinkScopes@2019-10-17-preview' = {
  name: name
  location: location
  tags: tags
  properties: {}
}

module privateLinkScope_scopedResource 'scopedResources/deploy.bicep' = [for (scopedResource, index) in scopedResources: {
  name: '${uniqueString(deployment().name, location)}-PvtLinkScope-ScopedRes-${index}'
  params: {
    name: scopedResource.name
    privateLinkScopeName: privateLinkScope.name
    linkedResourceId: scopedResource.linkedResourceId
  }
}]

resource privateLinkScope_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${privateLinkScope.name}-${lock}-lock'
  scope: privateLinkScope
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
}

module privateLinkScope_privateEndpoints '.bicep/nested_privateEndpoint.bicep' = [for (endpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-PvtLinkScope-PrivateEndpoint-${index}'
  params: {
    privateEndpointResourceId: privateLinkScope.id
    privateEndpointVnetLocation: reference(split(endpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    privateEndpointObj: endpoint
    tags: tags
  }
}]

module privateLinkScope_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-PvtLinkScope-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: privateLinkScope.id
  }
}]

@description('The name of the private link scope')
output privateLinkScopeName string = privateLinkScope.name

@description('The resource ID of the private link scope')
output privateLinkScopeResourceId string = privateLinkScope.id

@description('The resource group the private link scope was deployed into')
output privateLinkScopeResourceGroup string = resourceGroup().name

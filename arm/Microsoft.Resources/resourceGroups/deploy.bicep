targetScope = 'subscription'

@description('Required. The name of the Resource Group')
param resourceGroupName string

@description('Optional. Location of the Resource Group. It uses the deployment\'s location when not provided.')
param location string = deployment().location

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the storage account resource.')
param tags object = {}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2019-05-01' = {
  location: location
  name: resourceGroupName
  tags: tags
  properties: {}
}

module resourceGroup_lock '.bicep/nested_lock.bicep' = if (lock != 'NotSpecified') {
  scope: resourceGroup
  name: '${resourceGroup.name}-${lock}-lock-deployment'
  params: {
    name: '${resourceGroup.name}-${lock}-lock'
    level: lock
  }
}

module resourceGroup_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceGroupName: resourceGroup.name
  }
  scope: resourceGroup
}]

output resourceGroupName string = resourceGroup.name
output resourceGroupResourceId string = resourceGroup.id

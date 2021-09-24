targetScope = 'subscription'

@description('Required. The name of the Resource Group')
param resourceGroupName string

@description('Optional. Location of the Resource Group. It uses the deployment\'s location when not provided.')
param location string = deployment().location

@description('Optional. Switch to lock storage from deletion.')
param lockForDeletion bool = false

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

resource lockResource 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion == true) {
  name: '${resourceGroupName}-lock'
  properties: {
    level: 'CanNotDelete'
  }
}

module rbac './.bicep/nested_rbac.bicep' = [for (roleassignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}-${index}'
  scope: resourceGroup
  params: {
    roleAssignment: roleassignment
  }
  dependsOn: [
    resourceGroup
  ]
}]

output resourceGroupName string = resourceGroupName
output resourceGroupResourceId string = resourceGroup.id

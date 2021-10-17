targetScope = 'tenant'

@description('Optional.')
param managementGroupName string = ''

@description('Optional.')
param managementGroupId string

@description('Optional.')
param parentId string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

resource managementGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: managementGroupId
  properties: {
    displayName: managementGroupName
    details: !empty(parentId) ? {
      parent: {
        id: '/providers/Microsoft.Management/managementGroups/${parentId}'
      }
    } : json('null')
  }
}

module managementGroup_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}-${index}'
  scope: az.managementGroup(managementGroup.name)
  params: {
    managementGroupName: managementGroup.name
    roleAssignmentObj: roleAssignment
  }
}]

output managementGroupName string = managementGroup.name
output managementGroupId string = managementGroup.id

targetScope = 'managementGroup'

@description('Optional. The management group display name. Defaults to managementGroupId. ')
param name string = ''

@description('Required. The management group id.')
param managementGroupId string

@description('Optional. The management group parent id. Defaults to current scope.')
param parentId string = ''

@description('Optional. Array of role assignment objects to define RBAC on this resource.')
param roleAssignments array = []

resource managementGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: managementGroupId
  scope: tenant()
  properties: {
    displayName: name
    details: !empty(parentId) ? {
      parent: {
        id: '/providers/Microsoft.Management/managementGroups/${parentId}'
      }
    } : null
  }
}

module managementGroup_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceName: managementGroup.name
  }
  scope: managementGroup
}]

@description('The name of the management group')
output managementGroupName string = managementGroup.name

@description('The resource ID of the management group')
output managementGroupResourceId string = managementGroup.id

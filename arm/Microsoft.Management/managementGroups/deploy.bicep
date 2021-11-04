targetScope = 'managementGroup'

@description('Optional. The management group display name. Defaults to managementGroupId. ')
param managementGroupName string = ''

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
    displayName: managementGroupName
    details: !empty(parentId) ? {
      parent: {
        id: '/providers/Microsoft.Management/managementGroups/${parentId}'
      }
    } : json('null')
  }
}

module managementGroup_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    managementGroupName: managementGroup.name
    roleAssignmentObj: roleAssignment
  }
  scope: managementGroup
}]

output managementGroupName string = managementGroup.name
output managementGroupId string = managementGroup.id

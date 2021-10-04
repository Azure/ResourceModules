param roleAssignment object
param builtInRoleNames object
param resourceName string

resource nested_rbac 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${guid(resourceName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

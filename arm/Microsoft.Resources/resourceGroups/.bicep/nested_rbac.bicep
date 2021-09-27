param roleAssignment object
param builtInRoleNames object
param resourceGroupName string

resource roleAssigment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: guid(resourceGroupName, principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: principalId
  }
}]

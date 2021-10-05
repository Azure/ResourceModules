param roleAssignment object
param builtInRoleNames object
param resourceName string

resource roleAssigment 'Microsoft.Insights/privateLinkScopes/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${resourceName}/Microsoft.Authorization/${guid(resourceName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: principalId
  }
}]

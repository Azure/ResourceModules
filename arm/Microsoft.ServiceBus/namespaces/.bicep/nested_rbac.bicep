param roleAssignment object
param builtInRoleNames object
param namespaceName string

resource nested_rbac  'Microsoft.Web/sites/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${namespaceName}/Microsoft.Authorization/${guid(namespaceName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

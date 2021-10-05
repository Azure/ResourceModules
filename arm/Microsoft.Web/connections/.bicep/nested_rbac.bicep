param roleAssignment object
param builtInRoleNames object
param resourceName string

resource nested_rbac 'Microsoft.Web/connections/providers/roleAssignments@2018-09-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${resourceName}/Microsoft.Authorization/${guid(resourceName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

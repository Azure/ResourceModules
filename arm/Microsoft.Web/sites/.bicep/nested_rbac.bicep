param roleAssignment object
param builtInRoleNames object
param appName string

resource nested_rbac  'Microsoft.Web/sites/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${appName}/Microsoft.Authorization/${guid(appName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

param roleAssignment object
param builtInRoleNames object
param userMsiName string

resource nested_rbac 'Microsoft.ManagedIdentity/userAssignedIdentities/providers/roleAssignments@2020-04-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): {
  name: '${userMsiName}/Microsoft.Authorization/${guid(uniqueString(userMsiName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
  dependsOn: []
}]

param roleAssignment object
param builtInRoleNames object
param storageAccountName string

resource nested_rbac 'Microsoft.Storage/storageAccounts/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${storageAccountName}/Microsoft.Authorization/${guid(storageAccountName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

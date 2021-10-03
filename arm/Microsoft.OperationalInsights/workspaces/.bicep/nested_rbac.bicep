param roleAssignment object
param builtInRoleNames object
param logAnalyticsWorkspaceName string

resource nested_rbac 'Microsoft.Storage/storageAccounts/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${logAnalyticsWorkspaceName}/Microsoft.Authorization/${guid(logAnalyticsWorkspaceName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

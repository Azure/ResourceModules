param roleAssignmentObj object
param builtInRoleNames object
param logAnalyticsWorkspaceName string

resource roleAssigment 'Microsoft.Storage/storageAccounts/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: '${logAnalyticsWorkspaceName}/Microsoft.Authorization/${guid(logAnalyticsWorkspaceName, principalId, roleAssignmentObj.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]

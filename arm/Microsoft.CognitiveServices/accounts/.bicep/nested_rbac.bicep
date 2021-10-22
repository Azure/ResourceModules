param roleAssignmentObj object
param builtInRoleNames object
param resourceName string

resource roleAssignment 'Microsoft.CognitiveServices/accounts/providers/roleAssignments@2021-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: '${resourceName}/Microsoft.Authorization/${guid(resourceName, principalId, roleAssignmentObj.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]

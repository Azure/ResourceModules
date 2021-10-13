param roleAssignmentObj object
param builtInRoleNames object
param namespaceName string

resource roleAssignment 'Microsoft.EventHub/namespaces/providers/roleAssignments@2018-09-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: '${namespaceName}/Microsoft.Authorization/${guid(namespaceName, principalId, roleAssignmentObj.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]

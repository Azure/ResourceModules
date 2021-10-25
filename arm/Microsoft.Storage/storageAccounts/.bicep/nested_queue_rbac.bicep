param resourceName string
param roleAssignmentObj object
param builtInRoleNames object

resource roleAssignment 'Microsoft.Storage/storageAccounts/queueServices/queues/providers/roleAssignments@2021-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: '${resourceName}/Microsoft.Authorization/${(empty(roleAssignmentObj) ? guid(resourceName) : guid(resourceName, principalId, roleAssignmentObj.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]

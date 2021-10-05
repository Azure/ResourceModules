param queueName string
param roleAssignmentObj object
param builtInRoleNames object
param storageAccountName string

resource queue_rbac 'Microsoft.Storage/storageAccounts/queueServices/queues/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: '${storageAccountName}/default/${queueName}/Microsoft.Authorization/${(empty(roleAssignmentObj) ? guid(storageAccountName) : guid(storageAccountName, queueName, principalId, roleAssignmentObj.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]

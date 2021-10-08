param queueName string
param roleAssignment object
param builtInRoleNames object
param storageAccountName string

resource storageAccountName_default_queueName_Microsoft_Authorization_roleAssignment_storageAccountName_storageAccountName_queueName_roleAssignment_principalIds_containerRbacLoop_roleAssignment_roleDefinitionIdOrName 'Microsoft.Storage/storageAccounts/queueServices/queues/providers/roleAssignments@2018-09-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): if (!empty(roleAssignment)) {
  name: '${storageAccountName}/default/${queueName}/Microsoft.Authorization/${(empty(roleAssignment) ? guid(storageAccountName) : guid(storageAccountName, queueName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
}]
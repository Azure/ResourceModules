param queueName string
param roleAssignment object
param builtInRoleNames object
param storageAccountName string

resource queue_rbac 'Microsoft.Storage/storageAccounts/queueServices/queues/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
    name: '${storageAccountName}/default/${queueName}/Microsoft.Authorization/${(empty(roleAssignment) ? guid(storageAccountName) : guid(storageAccountName, queueName, principalId, roleAssignment.roleDefinitionIdOrName))}'
    properties: {
        roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
        principalId: principalId
    }
}]

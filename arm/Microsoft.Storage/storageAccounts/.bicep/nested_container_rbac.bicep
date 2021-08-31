param roleAssignment object
param blobContainerName string
param storageAccountName string
param builtInRoleNames object

resource container_rbac 'Microsoft.Storage/storageAccounts/blobServices/containers/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${storageAccountName}/default/${blobContainerName}/Microsoft.Authorization/${(empty(roleAssignment) ? guid(storageAccountName) : guid(storageAccountName, blobContainerName, principalId, roleAssignment.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: principalId
  }
}]

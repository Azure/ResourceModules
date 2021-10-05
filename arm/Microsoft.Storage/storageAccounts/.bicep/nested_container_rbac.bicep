param roleAssignmentObj object
param blobContainerName string
param storageAccountName string
param builtInRoleNames object

resource container_rbac 'Microsoft.Storage/storageAccounts/blobServices/containers/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: '${storageAccountName}/default/${blobContainerName}/Microsoft.Authorization/${(empty(roleAssignmentObj) ? guid(storageAccountName) : guid(storageAccountName, blobContainerName, principalId, roleAssignmentObj.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName
    principalId: principalId
  }
}]

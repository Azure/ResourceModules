param fileShareName string
param roleAssignment object
param builtInRoleNames object
param storageAccountName string

resource nested_fileShare_rbac 'Microsoft.Storage/storageAccounts/fileServices/fileshares/providers/roleAssignments@2018-09-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${storageAccountName}/default/${fileShareName}/Microsoft.Authorization/${(empty(roleAssignment) ? guid(storageAccountName) : guid(storageAccountName, fileShareName, principalId, roleAssignment.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
}]

param fileShareName string
param roleAssignmentObj object
param builtInRoleNames object
param storageAccountName string

resource roleAssignment 'Microsoft.Storage/storageAccounts/fileServices/fileshares/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: '${storageAccountName}/default/${fileShareName}/Microsoft.Authorization/${(empty(roleAssignmentObj) ? guid(storageAccountName) : guid(storageAccountName, fileShareName, principalId, roleAssignmentObj.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]

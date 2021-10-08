param fileShareName string
param roleAssignment object
param builtInRoleNames object
param storageAccountName string

resource storageAccountName_default_fileShareName_Microsoft_Authorization_roleAssignment_storageAccountName_storageAccountName_fileShareName_roleAssignment_principalIds_containerRbacLoop_roleAssignment_roleDefinitionIdOrName 'Microsoft.Storage/storageAccounts/fileServices/fileshares/providers/roleAssignments@2018-09-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): if (!empty(roleAssignment)) {
  name: '${storageAccountName}/default/${fileShareName}/Microsoft.Authorization/${(empty(roleAssignment) ? guid(storageAccountName) : guid(storageAccountName, fileShareName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
}]
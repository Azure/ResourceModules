param blobContainerName string
param roleAssignment object
param builtInRoleNames object
param storageAccountName string

resource storageAccountName_default_blobContainerName_Microsoft_Authorization_roleAssignment_storageAccountName_storageAccountName_blobContainerName_roleAssignment_principalIds_containerRbacLoop_roleAssignment_roleDefinitionIdOrName 'Microsoft.Storage/storageAccounts/blobServices/containers/providers/roleAssignments@2020-04-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): if (!empty(roleAssignment)) {
  name: '${storageAccountName}/default/${blobContainerName}/Microsoft.Authorization/${(empty(roleAssignment) ? guid(storageAccountName) : guid(storageAccountName, blobContainerName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
}]
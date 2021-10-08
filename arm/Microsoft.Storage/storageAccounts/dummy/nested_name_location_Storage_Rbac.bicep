param roleAssignment object
param builtInRoleNames object
param storageAccountName string

resource storageAccountName_Microsoft_Authorization_storageAccountName_roleAssignment_principalIds_storageInnerRbacCopy_roleAssignment_roleDefinitionIdOrName 'Microsoft.Storage/storageAccounts/providers/roleAssignments@2020-04-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): {
  name: '${storageAccountName}/Microsoft.Authorization/${guid(storageAccountName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
  dependsOn: []
}]
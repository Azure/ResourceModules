param roleAssignment object
param builtInRoleNames object
param keyVaultName string

resource keyVaultName_Microsoft_Authorization_keyVaultName_roleAssignment_principalIds_innerRbacCopy_roleAssignment_roleDefinitionIdOrName 'Microsoft.KeyVault/vaults/providers/roleAssignments@2018-09-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): {
  name: '${keyVaultName}/Microsoft.Authorization/${guid(uniqueString(concat(keyVaultName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName)))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
  dependsOn: []
}]
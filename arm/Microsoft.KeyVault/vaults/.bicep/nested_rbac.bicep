param roleAssignmentObj object
param builtInRoleNames object
param resourceName string

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: resourceName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: guid(resourceName, principalId, roleAssignmentObj.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
  scope: keyVault
}]

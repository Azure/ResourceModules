param roleAssignmentObj object
param builtInRoleNames object
param resourceName string

resource managedInstace 'Microsoft.Sql/managedInstances@2020-08-01-preview' existing = {
  name: resourceName
}

resource roleAssigment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: guid(managedInstace.name, principalId, roleAssignmentObj.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]

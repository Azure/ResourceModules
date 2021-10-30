param roleAssignmentObj object
param builtInRoleNames object
param resourceName string

resource server 'Microsoft.Sql/servers@2020-02-02-preview' existing = {
  name: resourceName
}

resource roleAssigment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: guid(resourceName, principalId, roleAssignmentObj.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
  scope: server
}]

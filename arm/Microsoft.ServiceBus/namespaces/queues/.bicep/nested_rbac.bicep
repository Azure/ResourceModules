param roleAssignmentObj object
param builtInRoleNames object
param resourceName string

resource queue 'Microsoft.ServiceBus/namespaces/queues@2021-06-01-preview' existing = {
  name: resourceName
}

resource roleAssigment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: guid(resourceName, principalId, roleAssignmentObj.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
  scope: queue
}]

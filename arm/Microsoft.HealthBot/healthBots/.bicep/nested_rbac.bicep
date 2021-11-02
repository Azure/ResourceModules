param roleAssignmentObj object
param builtInRoleNames object
param resourceName string

resource healthBot 'Microsoft.HealthBot/healthBots@2021-06-10' existing = {
  name: resourceName
}

resource roleAssigment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: '${guid(healthBot.name, principalId, roleAssignmentObj.roleDefinitionIdOrName)}'
  scope: healthBot
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]

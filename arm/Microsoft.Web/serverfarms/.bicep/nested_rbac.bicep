param roleAssignment object
param builtInRoleNames object
param appServicePlanName string

resource nested_rbac  'Microsoft.Web/sites/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${appServicePlanName}/Microsoft.Authorization/${guid(appServicePlanName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

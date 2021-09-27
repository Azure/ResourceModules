param roleAssignment object
param builtInRoleNames object
param appGroupName string

resource nested_rbac 'Microsoft.DesktopVirtualization/applicationgroups/providers/roleAssignments@2018-09-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${appGroupName}/Microsoft.Authorization/${guid(appGroupName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

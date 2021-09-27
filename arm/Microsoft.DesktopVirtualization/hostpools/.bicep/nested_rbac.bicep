param roleAssignment object
param builtInRoleNames object
param hostPoolName string

resource nested_rbac 'Microsoft.DesktopVirtualization/hostpools/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${hostPoolName}/Microsoft.Authorization/${guid(hostPoolName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

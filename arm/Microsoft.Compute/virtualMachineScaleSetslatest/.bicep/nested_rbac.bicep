param roleAssignment object
param builtInRoleNames object
param vmssName string

resource nested_rbac 'Microsoft.Compute/virtualMachineScaleSets/providers/roleAssignments@2018-09-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${vmssName}/Microsoft.Authorization/${guid(uniqueString('${vmssName}${principalId}${roleAssignment.roleDefinitionIdOrName}'))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

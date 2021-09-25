param roleAssignment object
param builtInRoleNames object
param vmssName string

resource nested_rbac 'Microsoft.Compute/virtualMachineScaleSets/providers/roleAssignments@2018-09-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): {
  name: '${vmssName}/Microsoft.Authorization/${guid(uniqueString('${vmssName}${array(roleAssignment.principalIds)[i]}${roleAssignment.roleDefinitionIdOrName}'))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
  dependsOn: []
}]

param roleAssignment object
param builtInRoleNames object
param vmName string

resource vmName_Microsoft_Authorization_vmName_roleAssignment_principalIds_innerRbacCopy_roleAssignment_roleDefinitionIdOrName 'Microsoft.Compute/virtualMachines/providers/roleAssignments@2018-09-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): {
  name: '${vmName}/Microsoft.Authorization/${guid(uniqueString(concat(vmName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName)))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
  dependsOn: []
}]
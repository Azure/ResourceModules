param roleAssignment object
param builtInRoleNames object
param netAppAccountName string

resource netAppAccountName_Microsoft_Authorization_netAppAccountName_roleAssignment_principalIds_netAppAccountInnerRbacCopy_roleAssignment_roleDefinitionIdOrName 'Microsoft.NetApp/netAppAccounts/providers/roleAssignments@2020-04-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): {
  name: '${netAppAccountName}/Microsoft.Authorization/${guid(netAppAccountName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
  dependsOn: []
}]
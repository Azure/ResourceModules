param netAppAccountName string
param capacityPoolName string
param roleAssignment object
param builtInRoleNames object

resource netAppAccountName_capacityPoolName_Microsoft_Authorization_roleAssignment_netAppAccountName_netAppAccountName_capacityPoolName_roleAssignment_principalIds_cpRbacLoop_roleAssignment_roleDefinitionIdOrName 'Microsoft.NetApp/netAppAccounts/capacityPools/providers/roleAssignments@2020-04-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): if (!empty(roleAssignment)) {
  name: '${netAppAccountName}/${capacityPoolName}/Microsoft.Authorization/${(empty(roleAssignment) ? guid(netAppAccountName) : guid(netAppAccountName, capacityPoolName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
}]
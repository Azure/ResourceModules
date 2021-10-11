param netAppAccountName string
param capacityPoolName string
param volumeName string
param roleAssignment object
param builtInRoleNames object

resource netAppAccountName_capacityPoolName_volumeName_Microsoft_Authorization_roleAssignment_netAppAccountName_netAppAccountName_capacityPoolName_volumeName_roleAssignment_principalIds_volumeRbacLoop_roleAssignment_roleDefinitionIdOrName 'Microsoft.NetApp/netAppAccounts/capacityPools/volumes/providers/roleAssignments@2020-04-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): if (!empty(roleAssignment)) {
  name: '${netAppAccountName}/${capacityPoolName}/${volumeName}/Microsoft.Authorization/${(empty(roleAssignment) ? guid(netAppAccountName) : guid(netAppAccountName, capacityPoolName, volumeName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
}]
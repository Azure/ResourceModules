targetScope = 'tenant'
param MGName string
param roleAssignment object
param builtInRoleNames object

resource MGName_Microsoft_Authorization_MGName_roleAssignment_principalIds_innerRbacCopy_roleAssignment_roleDefinitionIdOrName 'Microsoft.Management/managementGroups/providers/roleAssignments@2020-04-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): {
  name: '${MGName}/Microsoft.Authorization/${guid(uniqueString(concat(MGName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName)))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
}]
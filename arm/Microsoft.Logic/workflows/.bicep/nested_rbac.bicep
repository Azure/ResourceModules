param roleAssignment object
param builtInRoleNames object
param logicAppName string

resource logicAppName_Microsoft_Authorization_logicAppName_roleAssignment_principalIds_innerRbacCopy_roleAssignment_roleDefinitionIdOrName 'Microsoft.Logic/workflows/providers/roleAssignments@2018-09-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${logicAppName}/Microsoft.Authorization/${guid(uniqueString('${logicAppName}${principalId}${roleAssignment.roleDefinitionIdOrName}'))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

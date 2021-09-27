param roleAssignment object
param builtInRoleNames object
param galleryName string

resource nested_rbac 'Microsoft.Compute/galleries/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${galleryName}/Microsoft.Authorization/${guid(uniqueString('${galleryName}${principalId}${roleAssignment.roleDefinitionIdOrName}'))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]

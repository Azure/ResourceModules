param blobContainer object
param builtInRoleNames object
param storageAccountName string

module name_Rbac_blobContainer_roleAssignments_dummy './nested_name_Rbac_blobContainer_roleAssignments_dummy.bicep' = [for i in range(0, length(array(blobContainer.roleAssignments))): {
  name: '${deployment().name}-Rbac-${(empty(blobContainer.roleAssignments) ? 'dummy' : i)}'
  params: {
    blobContainerName: blobContainer.name
    roleAssignment: array(blobContainer.roleAssignments)[i]
    builtInRoleNames: builtInRoleNames
    storageAccountName: storageAccountName
  }
  dependsOn: []
}]
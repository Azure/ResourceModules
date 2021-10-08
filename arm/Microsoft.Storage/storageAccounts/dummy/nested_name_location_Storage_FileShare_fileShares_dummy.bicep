param fileShare object
param builtInRoleNames object
param storageAccountName string

module name_Rbac_fileShare_roleAssignments_dummy './nested_name_Rbac_fileShare_roleAssignments_dummy.bicep' = [for i in range(0, length(array(fileShare.roleAssignments))): {
  name: '${deployment().name}-Rbac-${(empty(fileShare.roleAssignments) ? 'dummy' : i)}'
  params: {
    fileShareName: fileShare.name
    roleAssignment: array(fileShare.roleAssignments)[i]
    builtInRoleNames: builtInRoleNames
    storageAccountName: storageAccountName
  }
  dependsOn: []
}]
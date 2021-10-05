param fileShare object
param builtInRoleNames object
param storageAccountName string

resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2019-06-01' = {
  name: '${storageAccountName}/default/${fileShare.name}'
  properties: {
    shareQuota: fileShare.shareQuota
  }
}

module nested_fileShare_rbac './nested_fileShare_rbac.bicep' = [for (roleAssignment, index) in fileShare.roleAssignments: {
  name: '${deployment().name}-Rbac-${(empty(fileShare.roleAssignments) ? 'dummy' : index)}'
  params: {
    fileShareName: fileShare.name
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    storageAccountName: storageAccountName
  }
  dependsOn: [
    share
  ]
}]

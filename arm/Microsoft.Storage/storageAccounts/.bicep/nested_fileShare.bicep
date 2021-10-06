param fileShareObj object
param builtInRoleNames object
param storageAccountName string

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2019-06-01' = {
  name: '${storageAccountName}/default/${fileShareObj.name}'
  properties: {
    shareQuota: fileShareObj.shareQuota
  }
}

module fileShare_rbac './nested_fileShare_rbac.bicep' = [for (roleAssignment, index) in fileShareObj.roleAssignments: {
  name: '${deployment().name}-Rbac-${(empty(fileShareObj.roleAssignments) ? 'dummy' : index)}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: fileShare.name
  }
}]

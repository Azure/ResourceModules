param blobContainer object
param builtInRoleNames object
param storageAccountName string

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName}/default/${blobContainer.name}'
  properties: {
    publicAccess: blobContainer.publicAccess
  }
}

resource container_policy 'Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2019-06-01' = if (contains(blobContainer, 'enableWORM') && blobContainer.enableWORM) {
  name: '${storageAccountName}/default/${blobContainer.name}/default'
  properties: {
    immutabilityPeriodSinceCreationInDays: (contains(blobContainer, 'WORMRetention') ? blobContainer.WORMRetention : 365)
    allowProtectedAppendWrites: contains(blobContainer, 'allowProtectedAppendWrites') ? blobContainer.allowProtectedAppendWrites : true
  }
  dependsOn: [
    container
  ]
}

module container_rbac './nested_container_rbac.bicep' = [for (roleAssignment, index) in blobContainer.roleAssignments: {
  name: '${deployment().name}-Rbac-${(empty(blobContainer.roleAssignments) ? 'dummy' : index)}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: container.name
  }
}]

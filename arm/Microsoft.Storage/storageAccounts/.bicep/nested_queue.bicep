param queueObj object
param builtInRoleNames object
param storageAccountName string

resource queue 'Microsoft.Storage/storageAccounts/queueServices/queues@2019-06-01' = {
  name: '${storageAccountName}/default/${queueObj.name}'
  properties: {
    metadata: (contains(queueObj, 'metadata') ? queueObj.metadata : json('null'))
  }
}

module queue_rbac './nested_queue_rbac.bicep' = [for (roleAssignment, index) in queueObj.roleAssignments: {
  name: '${deployment().name}-Rbac-${(empty(queueObj.roleAssignments) ? 'dummy' : index)}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: queue.name
  }
}]

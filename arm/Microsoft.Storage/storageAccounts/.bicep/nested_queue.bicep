param queue object
param builtInRoleNames object
param storageAccountName string

resource queueObject 'Microsoft.Storage/storageAccounts/queueServices/queues@2019-06-01' = {
  name: '${storageAccountName}/default/${queue.name}'
  properties: {
    metadata: (contains(queue, 'metadata') ? queue.metadata : json('null'))
  }
}

module nested_queue_rbac './nested_queue_rbac.bicep' = [for (roleassignment, index) in queue.roleAssignments: {
  name: '${deployment().name}-Rbac-${(empty(queue.roleAssignments) ? 'dummy' : index)}'
  params: {
    queueName: queue.name
    roleAssignment: roleassignment
    builtInRoleNames: builtInRoleNames
    storageAccountName: storageAccountName
  }
  dependsOn: [
    queueObject
  ]
}]

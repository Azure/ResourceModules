param queue object
param builtInRoleNames object
param storageAccountName string

module name_Rbac_queue_roleAssignments_dummy './nested_name_Rbac_queue_roleAssignments_dummy.bicep' = [for i in range(0, length(array(queue.roleAssignments))): {
  name: '${deployment().name}-Rbac-${(empty(queue.roleAssignments) ? 'dummy' : i)}'
  params: {
    queueName: queue.name
    roleAssignment: array(queue.roleAssignments)[i]
    builtInRoleNames: builtInRoleNames
    storageAccountName: storageAccountName
  }
  dependsOn: []
}]
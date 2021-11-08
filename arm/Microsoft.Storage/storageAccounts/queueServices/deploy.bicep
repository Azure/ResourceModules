@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. Queues to create.')
param queues array = []

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource queueService 'Microsoft.Storage/storageAccounts/queueServices@2021-04-01' = {
  name: '${storageAccountName}/default'
  properties: {}
}

module queueService_queues 'queues/deploy.bicep' = [for (queue, index) in queues: {
  name: '${deployment().name}-Storage-Queue-${index}'
  params: {
    storageAccountName: storageAccountName
    name: queue.name
    metadata: contains(queue, 'metadata') ? queue.metadata : {}
    roleAssignments: contains(queue, 'roleAssignments') ? queue.roleAssignments : []
  }
  dependsOn: [
    queueService
  ]
}]


output queueServiceName string = queueService.name


output queueServiceResourceId string = queueService.id


output queueServiceResourceGroup string = resourceGroup().name

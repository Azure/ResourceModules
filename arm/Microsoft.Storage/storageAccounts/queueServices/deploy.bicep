@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. The name of the queue service')
param name string = 'default'

@description('Optional. Queues to create.')
param queues array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName

  resource queueServices 'queueServices@2021-04-01' = {
    name: name
    properties: {}
  }
}

module queueServices_queues 'queues/deploy.bicep' = [for (queue, index) in queues: {
  name: '${deployment().name}-Storage-Queue-${index}'
  params: {
    storageAccountName: storageAccount.name
    queueServicesName: storageAccount::queueServices.name
    name: queue.name
    metadata: contains(queue, 'metadata') ? queue.metadata : {}
    roleAssignments: contains(queue, 'roleAssignments') ? queue.roleAssignments : []
  }
}]

@description('The name of the deployed file share service')
output queueServicesName string = storageAccount::queueServices.name

@description('The resource ID of the deployed file share service')
output queueServicesResourceId string = storageAccount::queueServices.id

@description('The resource group of the deployed file share service')
output queueServicesResourceGroup string = resourceGroup().name

@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Sets the CORS rules. You can include up to five CorsRule elements in the request.')
param cors object = {}

@description('Optional. Queues to create.')
param queues array = []

resource queueService 'Microsoft.Storage/storageAccounts/queueServices@2021-04-01' = {
  name: '${storageAccountName}/default'
  properties: {
    cors: cors
  }
}

module queueService_queues '.queues/deploy.bicep' = [for (queue, index) in queues: {
  name: '${uniqueString(deployment().name)}-Storage-File-${(empty(queue) ? 'dummy' : index)}'
  params: {
    storageAccountName: storageAccountName
    name: queue.name
    metadata: queue.metadata
    roleAssignments: queue.roleAssignments
  }
}]

@description('The name of the deployed file share service')
output queueServiceName string = queueService.name

@description('The id of the deployed file share service')
output queueServiceResourceId string = queueService.id

@description('The resource group of the deployed file share service')
output queueServiceResourceGroup string = resourceGroup().name

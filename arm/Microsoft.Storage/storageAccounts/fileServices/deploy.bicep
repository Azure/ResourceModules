@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. The name of the file service')
param name string = 'default'

@description('Protocol settings for file service')
param protocolSettings object = {}

@description('The service properties for soft delete.')
param shareDeleteRetentionPolicy object = {
  enabled: true
  days: 7
}

@description('Optional. File shares to create.')
param shares array = []

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName
}

resource fileServices 'Microsoft.Storage/storageAccounts/fileServices@2021-04-01' = {
  name: name
  parent: storageAccount
  properties: {
    protocolSettings: protocolSettings
    shareDeleteRetentionPolicy: shareDeleteRetentionPolicy
  }
}

module fileServices_shares 'shares/deploy.bicep' = [for (share, index) in shares: {
  name: '${deployment().name}-Storage-File-${index}'
  params: {
    storageAccountName: storageAccountName
    fileServicesName: fileServices.name
    name: share.name
    sharedQuota: contains(share, 'sharedQuota') ? share.sharedQuota : 5120
    roleAssignments: contains(share, 'roleAssignments') ? share.roleAssignments : []
  }
}]

@description('The name of the deployed file share service')
output fileServiceName string = last(split(fileServices.name, '/'))

@description('The id of the deployed file share service')
output fileServiceResourceId string = fileServices.id

@description('The resource group of the deployed file share service')
output fileServiceResourceGroup string = resourceGroup().name

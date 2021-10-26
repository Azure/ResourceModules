@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Sets the CORS rules. You can include up to five CorsRule elements in the request.')
param cors object = {}

@description('Protocol settings for file service')
param protocolSettings object = {}

@description('The service properties for soft delete.')
param shareDeleteRetentionPolicy object = {
  enabled: true
  days: 7
}

@description('Optional. File shares to create.')
param fileShares array = []

resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2021-06-01' = {
  name: '${storageAccountName}/default'
  properties: {
    cors: cors
    protocolSettings: protocolSettings
    shareDeleteRetentionPolicy: shareDeleteRetentionPolicy
  }
}

module fileService_fileShares '.shares/deploy.bicep' = [for (fileShare, index) in fileShares: {
  name: '${uniqueString(deployment().name)}-Storage-File-${(empty(fileShare) ? 'dummy' : index)}'
  params: {
    storageAccountName: storageAccountName
    name: fileShare.name
    sharedQuota: contains(fileShare, 'sharedQuota') ? fileShare.sharedQuota : 5120
    roleAssignments: contains(fileShare, 'roleAssignments') ? fileShare.roleAssignments : []
  }
}]

@description('The name of the deployed file share service')
output fileServiceName string = fileService.name

@description('The id of the deployed file share service')
output fileServiceResourceId string = fileService.id

@description('The resource group of the deployed file share service')
output fileServiceResourceGroup string = resourceGroup().name

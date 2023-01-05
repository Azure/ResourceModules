@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

module storageAccount '../../../../Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: storageAccountName
  params: {
    name: storageAccountName
    enableDefaultTelemetry: true
    allowBlobPublicAccess: false
    location: location
    storageAccountSku: 'Standard_LRS'
    storageAccountKind: 'StorageV2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
    }
  }
}

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.outputs.resourceId

@description('The name of the created Storage Account.')
output storageAccountName string = storageAccount.outputs.name
